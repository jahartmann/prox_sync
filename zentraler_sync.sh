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

# ASCII-Kunst-Logo für Prox_Sync
echo_color "cyan" "
██████╗ ██████╗  ██████╗ ██╗  ██╗        ███████╗██╗   ██╗███╗   ██╗ ██████╗
██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝        ██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝
██████╔╝██████╔╝██║   ██║ ╚███╔╝         ███████╗ ╚████╔╝ ██╔██╗ ██║██║     
██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗         ╚════██║  ╚██╔╝  ██║╚██╗██║██║     
██║     ██║  ██║╚██████╔╝██╔╝ ██╗███████╗███████║   ██║   ██║ ╚████║╚██████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝
"

echo_color "cyan" " Willkommen zum PBS_Sync Backup-Skript "

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

# Datum für Backup-Ordner
DATE=$(date +"%d-%B-%Y")

# Backup-Verzeichnisse erstellen
echo_color "magenta" "Erstelle Backup-Verzeichnis für Nodes: ${NODE_LOCAL_DIR}${DATE}"
mkdir -p "${NODE_LOCAL_DIR}${DATE}"

echo_color "magenta" "Erstelle Backup-Verzeichnis für Backup-Server: ${SERVER_LOCAL_DIR}${DATE}"
mkdir -p "${SERVER_LOCAL_DIR}${DATE}"

# Konfigurationen von jedem Proxmox-Node sichern
for NODE_NAME in "${!NODES[@]}"; do
    NODE_IP=${NODES[$NODE_NAME]}
    echo
    echo_color "yellow" "=============================="
    echo_color "yellow" "Sichere Konfigurationen von ${NODE_NAME} (${NODE_IP})..."
    echo_color "yellow" "=============================="

    # Rsync-Befehl ausführen
    rsync -avz --delete "${USER}@${NODE_IP}:${REMOTE_DIR}" "${NODE_LOCAL_DIR}${DATE}/${NODE_NAME}"

    echo_color "green" "Konfigurationen von ${NODE_NAME} gesichert."
    echo
done

# Konfigurationen von jedem Backup-Server sichern
for SERVER_NAME in "${!BACKUP_SERVERS[@]}"; do
    SERVER_IP=${BACKUP_SERVERS[$SERVER_NAME]}
    echo
    echo_color "yellow" "=============================="
    echo_color "yellow" "Sichere Konfigurationen von ${SERVER_NAME} (${SERVER_IP})..."
    echo_color "yellow" "=============================="

    # Rsync-Befehl ausführen
    rsync -avz --delete "${USER}@${SERVER_IP}:${BACKUP_DIR}" "${SERVER_LOCAL_DIR}${DATE}/${SERVER_NAME}"

    echo_color "green" "Konfigurationen von ${SERVER_NAME} gesichert."
    echo
done

echo_color "cyan" "##############################"
echo_color "cyan" "# Alle Backups abgeschlossen #"
echo_color "cyan" "##############################"