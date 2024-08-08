#!/bin/bash

# Funktion, um Text in Farbe auszugeben
# Farben: Rot, Grün, Gelb, Blau, Lila, Cyan, Weiß
function echo_color {
    local color=$1
    local text=$2
    case $color in
        "red")    echo -e "\033[31m$text\033[0m" ;;
        "green")  echo -e "\033[32m$text\033[0m" ;;
        "yellow") echo -e "\033[33m$text\033[0m" ;;
        "blue")   echo -e "\033[34m$text\033[0m" ;;
        "purple") echo -e "\033[35m$text\033[0m" ;;
        "cyan")   echo -e "\033[36m$text\033[0m" ;;
        "white")  echo -e "\033[37m$text\033[0m" ;;
        *)        echo "$text" ;;
    esac
}

# Ladeanimation
function loading_animation {
    echo -n "Bitte warten"
    for i in {1..5}; do
        echo -n "."
        sleep 0.3
    done
    echo ""
}

# ASCII-Kunst-Logo für ProxSync
echo_color "cyan" "
██████╗ ██████╗  ██████╗ ██╗  ██╗        ███████╗██╗   ██╗███╗   ██╗ ██████╗
██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝        ██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝
██████╔╝██████╔╝██║   ██║ ╚███╔╝         ███████╗ ╚████╔╝ ██╔██╗ ██║██║     
██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗         ╚════██║  ╚██╔╝  ██║╚██╗██║██║     
██║     ██║  ██║╚██████╔╝██╔╝ ██╗███████╗███████║   ██║   ██║ ╚████║╚██████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝
"

echo_color "cyan" " Willkommen zum Prox_Sync Backup-Skript "

# Liste der Proxmox-Nodes
declare -A NODES=(
    ["Node1"]="IP-Adresse 1"
    ["Node2"]="IP-Adresse 2"
    ["Node3"]="IP-Adresse 3"
    
    
)

USER="root"
REMOTE_DIR="/etc/pve/"  # Standardverzeichnis mit den Proxmox-Konfigurationen
LOCAL_DIR="/backup/proxmox-configs/"  # Lokales Backup-Verzeichnis auf CBS-Z

# Verfügbare Backup-Daten anzeigen
echo_color "yellow" "Verfügbare Backup-Daten:"
BACKUP_DATES=($(ls -d "${LOCAL_DIR}"*/ | xargs -n 1 basename))

# Überprüfen, ob Backups vorhanden sind
if [ ${#BACKUP_DATES[@]} -eq 0 ]; then
    echo_color "red" "Keine Backups gefunden."
    exit 1
fi

# Backup-Daten mit Nummer anzeigen
for i in "${!BACKUP_DATES[@]}"; do
    echo_color "green" "[$i] ${BACKUP_DATES[$i]}"
done

# Benutzer zur Auswahl eines Backup-Datums auffordern
read -p "Wählen Sie das Datum des Backups aus, das Sie wiederherstellen möchten (Nummer eingeben): " DATE_INDEX

# Prüfen, ob die Auswahl gültig ist
if ! [[ "$DATE_INDEX" =~ ^[0-9]+$ ]] || [ "$DATE_INDEX" -ge "${#BACKUP_DATES[@]}" ]; then
    echo_color "red" "Ungültige Auswahl."
    exit 1
fi

SELECTED_DATE="${BACKUP_DATES[$DATE_INDEX]}"
echo_color "blue" "Ausgewähltes Datum: $SELECTED_DATE"

# Verfügbare Nodes anzeigen
echo_color "yellow" "Verfügbare Nodes:"
NODE_NAMES=("${!NODES[@]}")
for i in "${!NODE_NAMES[@]}"; do
    echo_color "green" "[$i] ${NODE_NAMES[$i]} (${NODES[${NODE_NAMES[$i]}]})"
done

# Benutzer zur Auswahl eines Nodes auffordern
read -p "Wählen Sie den Node aus, den Sie wiederherstellen möchten (Nummer eingeben): " NODE_INDEX

# Prüfen, ob die Auswahl gültig ist
if ! [[ "$NODE_INDEX" =~ ^[0-9]+$ ]] || [ "$NODE_INDEX" -ge "${#NODE_NAMES[@]}" ]; then
    echo_color "red" "Ungültige Auswahl."
    exit 1
fi

SELECTED_NODE="${NODE_NAMES[$NODE_INDEX]}"
NODE_IP="${NODES[$SELECTED_NODE]}"
echo_color "blue" "Wiederherstellung der Konfiguration für $SELECTED_NODE ($NODE_IP)..."

# Ladeanimation
loading_animation

# Optionen für rsync, um Berechtigungsprobleme zu vermeiden und fortzufahren
RSYNC_OPTIONS=(
    -avz
    --ignore-errors
    --no-times
    --no-perms
    --no-owner
    --no-group
    --copy-links
    --exclude="pve/nodes/*/lrm_status"
    --exclude="pve/.rrd"
    --exclude="pve/.*"
    --exclude="pve/nodes/.*"
    --exclude=".rrd"
    --exclude=".lrm_status"
#    --rsync-path="sudo rsync"
)

# Wiederherstellung mit rsync, überspringt nicht übertragbare Dateien
rsync "${RSYNC_OPTIONS[@]}" "${LOCAL_DIR}${SELECTED_DATE}/${SELECTED_NODE}/" "${USER}@${NODE_IP}:${REMOTE_DIR}"

if [ $? -eq 0 ]; then
    echo_color "green" "Wiederherstellung abgeschlossen."
    
    # Ladeanimation für die Zertifikataktualisierung
    loading_animation

    # Aktualisierung der Zertifikate auf dem Ziel-Node
    echo_color "yellow" "Aktualisierung der Zertifikate auf $SELECTED_NODE..."
    ssh "${USER}@${NODE_IP}" "pvecm updatecerts --force"
    if [ $? -eq 0 ]; then
        echo_color "green" "Zertifikate erfolgreich aktualisiert."
    else
        echo_color "red" "Fehler bei der Aktualisierung der Zertifikate."
    fi 
else
    echo_color "red" "Wiederherstellung abgeschlossen."
    
    # Ladeanimation für die Zertifikataktualisierung
    loading_animation

    # Aktualisierung der Zertifikate auf dem Ziel-Node
    echo_color "yellow" "Aktualisierung der Zertifikate auf $SELECTED_NODE..."
    ssh "${USER}@${NODE_IP}" "pvecm updatecerts --force"
    if [ $? -eq 0 ]; then
        echo_color "green" "Zertifikate erfolgreich aktualisiert."
    else
        echo_color "red" "Fehler bei der Aktualisierung der Zertifikate."
    fi 
fi
