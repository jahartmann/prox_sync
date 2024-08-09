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

# Liste der Nodes (anonymisiert)
declare -A NODES=(
    ["Node-01"]="192.168.0.1"
    ["Node-02"]="192.168.0.2"
    ["Node-03"]="192.168.0.3"
    ["Node-04"]="192.168.0.4"
    ["Node-05"]="192.168.0.5"
)

# Liste der Backup-Server (anonymisiert)
declare -A BACKUP_SERVERS=(
    ["Backup-01"]="192.168.0.101"
    ["Backup-02"]="192.168.0.102"
    ["Backup-03"]="192.168.0.103"
    ["Backup-04"]="192.168.0.104"
    ["Backup-05"]="192.168.0.105"
)

USER="Root"
REMOTE_DIR="/etc/pve/"  # Standardverzeichnis mit den Konfigurationen
NODE_LOCAL_DIR="/data/backup/nodes/"  # Lokales Backup-Verzeichnis für Nodes
SERVER_LOCAL_DIR="/data/backup/backup-servers/"  # Lokales Backup-Verzeichnis für Backup-Server
BACKUP_DIR="/etc/proxmox-backup/"  # Festes Verzeichnis für die Backup-Server

# Auswahl: Node oder Backup-Server wiederherstellen
echo_color "yellow" "Was möchten Sie wiederherstellen?"
echo_color "green" "[1] Proxmox Node"
echo_color "green" "[2] Backup-Server"
read -p "Wählen Sie eine Option (1 oder 2): " RESTORE_OPTION

# Verfügbare Nodes oder Backup-Server anzeigen und Auswahl treffen
if [ "$RESTORE_OPTION" == "1" ]; then
    # Proxmox Node wiederherstellen
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

    # Wiederherstellung mit rsync
    rsync -avz --delete "${NODE_LOCAL_DIR}${SELECTED_DATE}/${SELECTED_NODE}/" "${USER}@${NODE_IP}:${REMOTE_DIR}"

elif [ "$RESTORE_OPTION" == "2" ]; then
    # Backup-Server wiederherstellen
    echo_color "yellow" "Verfügbare Backup-Server:"
    SERVER_NAMES=("${!BACKUP_SERVERS[@]}")
    for i in "${!SERVER_NAMES[@]}"; do
        echo_color "green" "[$i] ${SERVER_NAMES[$i]} (${BACKUP_SERVERS[${SERVER_NAMES[$i]}]})"
    done

    # Benutzer zur Auswahl eines Backup-Servers auffordern
    read -p "Wählen Sie den Backup-Server aus, den Sie wiederherstellen möchten (Nummer eingeben): " SERVER_INDEX

    # Prüfen, ob die Auswahl gültig ist
    if ! [[ "$SERVER_INDEX" =~ ^[0-9]+$ ]] || [ "$SERVER_INDEX" -ge "${#SERVER_NAMES[@]}" ]; then
        echo_color "red" "Ungültige Auswahl."
        exit 1
    fi

    SELECTED_SERVER="${SERVER_NAMES[$SERVER_INDEX]}"
    SERVER_IP="${BACKUP_SERVERS[$SELECTED_SERVER]}"
    echo_color "blue" "Wiederherstellung der Konfiguration für $SELECTED_SERVER ($SERVER_IP)..."

    # Ladeanimation
    loading_animation

    # Wiederherstellung mit rsync
    rsync -avz --delete "${SERVER_LOCAL_DIR}${SELECTED_DATE}/${SELECTED_SERVER}/" "${USER}@${SERVER_IP}:${BACKUP_DIR}"

else
    echo_color "red" "Ungültige Auswahl."
    exit 1
fi

# Zertifikatsaktualisierung auf dem Ziel-System
if [ $? -eq 0 ]; then
    echo_color "green" "Wiederherstellung abgeschlossen."

    # Ladeanimation für die Zertifikataktualisierung
    loading_animation

    echo_color "yellow" "Aktualisierung der Zertifikate auf $SELECTED_NODE oder $SELECTED_SERVER..."
    ssh "${USER}@${NODE_IP:-$SERVER_IP}" "pvecm updatecerts --force"
    if [ $? -eq 0 ]; then
        echo_color "green" "Zertifikate erfolgreich aktualisiert."
    else
        echo_color "red" "Fehler bei der Aktualisierung der Zertifikate."
    fi
else
    echo_color "red" "Wiederherstellung fehlgeschlagen."
fi