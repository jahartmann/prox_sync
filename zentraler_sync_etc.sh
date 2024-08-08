#!/bin/bash

# Funktion, um farbigen Text anzuzeigen
echo_color() {
  local color="$1"
  local text="$2"
  local color_code

  case "$color" in
    "red") color_code="\033[0;31m" ;;    # Rot
    "green") color_code="\033[0;32m" ;;  # Grün
    "yellow") color_code="\033[0;33m" ;; # Gelb
    "blue") color_code="\033[0;34m" ;;   # Blau
    "magenta") color_code="\033[0;35m" ;;# Magenta
    "cyan") color_code="\033[0;36m" ;;   # Cyan
    "white") color_code="\033[0;37m" ;;  # Weiß
    *) color_code="\033[0m" ;;           # Standardfarbe
  esac

  echo -e "${color_code}${text}\033[0m"
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
REMOTE_DIR="/etc/"  # Verzeichnis mit den Proxmox-Konfigurationen
LOCAL_DIR="/backup/proxmox-configs-etc/"  # Lokales Backup-Verzeichnis auf CBS-Z

# Datum für Backup-Ordner
DATE=$(date +"%d-%B-%Y")

# Funktion für die Animation (einfaches Laden)
loading_animation() {
    local -a chars=('/' '-' '\' '|')
    for i in {1..10}; do
        for j in "${chars[@]}"; do
            echo -ne "\r$j Backup wird durchgeführt..."
            sleep 0.1
        done
    done
    echo -ne "\rBackup abgeschlossen!   \n"
}

# Backup-Verzeichnis erstellen
echo_color "magenta" "Erstelle Backup-Verzeichnis: ${LOCAL_DIR}${DATE}"
mkdir -p "${LOCAL_DIR}${DATE}"

# Konfigurationen von jedem Node sichern
for NODE_NAME in "${!NODES[@]}"; do
    NODE_IP=${NODES[$NODE_NAME]}
    echo
    echo_color "yellow" "=============================="
    echo_color "yellow" "Sichere Konfigurationen von ${NODE_NAME} (${NODE_IP})..."
    echo_color "yellow" "=============================="

    # Animation starten
    loading_animation
    
    # Rsync-Befehl ausführen
    rsync -avz --delete "${USER}@${NODE_IP}:${REMOTE_DIR}" "${LOCAL_DIR}${DATE}/${NODE_NAME}"

    echo_color "green" "Konfigurationen von ${NODE_NAME} gesichert."
    echo
done

echo_color "cyan" "##############################"
echo_color "cyan" "# Alle Backups abgeschlossen #"
echo_color "cyan" "##############################"
