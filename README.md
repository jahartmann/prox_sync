# Proxmox Host & Backup Server Backup Sync Scripts

[Für Deutsch hier klicken](#proxmox-host-backup-sync-skripte)

Welcome to the Proxmox Host Backup Sync GitHub repository! This repository contains a collection of Bash scripts designed to facilitate the backup and restoration of Proxmox configurations across multiple hosts and backup servers. The scripts support synchronizing configurations from `/etc/pve` as well as the entire `/etc` directory to ensure comprehensive backup and restoration functionality. The scripts are executed from a central PC or VM and store the configurations in separate locations for hosts and backup servers.

## Features

- **Backup Configurations**: Synchronize configurations from multiple Proxmox hosts and backup servers to a central backup location.
- **Restore Configurations**: Restore configurations from the central backup to any Proxmox host or backup server.
- **Color-Coded Output**: Clear and visually distinct outputs for easy tracking of script progress.
- **Loading Animation**: Displays the progress of backup and restoration operations.

## Script Overview

### zentraler_sync.sh

This script synchronizes the Proxmox configurations from the `/etc/pve` and `/etc/proxmox-backup`directory of multiple hosts and backup servers to a central backup directory.

- **Define Hosts and IP Addresses**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Address-1"
      ["Host-Name-2"]="IP-Address-2"
      ...
  )
  ```
  Replace placeholders `Host-Name-1`, `IP-Address-1`, etc. with your specific host names and IP addresses.

- **Define Backup Servers and IP Addresses**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Address-1"
      ["Backup-Server-2"]="IP-Address-2"
      ...
  )
  ```

- **Set Backup Directory**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts/"  # Local backup directory for hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers/"  # Local backup directory for backup servers
  ```

### zentraler_sync_etc.sh

This script synchronizes the entire `/etc` directory of multiple hosts and backup servers to a central backup directory.

- **Define Hosts and IP Addresses**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Address-1"
      ["Host-Name-2"]="IP-Address-2"
      ...
  )
  ```

- **Define Backup Servers and IP Addresses**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Address-1"
      ["Backup-Server-2"]="IP-Address-2"
      ...
  )
  ```

- **Set Backup Directory**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts-etc/"  # Local backup directory for hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers-etc/"  # Local backup directory for backup servers
  ```

### zentraler_restore.sh

This script allows restoring Proxmox configurations from the central backup directory to a specified host or backup server. Users can select the desired backup date and the host or backup server for restoration.

- **Define Hosts and IP Addresses**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Address-1"
      ["Host-Name-2"]="IP-Address-2"
      ...
  )
  ```

- **Define Backup Servers and IP Addresses**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Address-1"
      ["Backup-Server-2"]="IP-Address-2"
      ...
  )
  ```

- **Set Backup Directory**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts/"  # Local backup directory for hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers/"  # Local backup directory for backup servers
  ```

### zentraler_restore_etc.sh

Similar to `zentraler_restore.sh`, this script allows restoring the entire `/etc` directory from the central backup directory to a specified host or backup server.

- **Define Hosts and IP Addresses**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Address-1"
      ["Host-Name-2"]="IP-Address-2"
      ...
  )
  ```

- **Define Backup Servers and IP Addresses**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Address-1"
      ["Backup-Server-2"]="IP-Address-2"
      ...
  )
  ```

- **Set Backup Directory**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts-etc/"  # Local backup directory for hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers-etc/"  # Local backup directory for backup servers
  ```

## Set Up SSH Keys

To run the scripts without entering a password, you need to set up SSH keys for the connection between the backup server and the Proxmox hosts and backup servers.

### Generate SSH Keys

1. Create an SSH key pair on the central server:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "Your Comment"
   ```
   Follow the instructions and save the key in the default path (`~/.ssh/id_rsa`).

2. Copy the public key to each Proxmox host and backup server:
   ```bash
   ssh-copy-id root@IP-Address
   ```
   Replace `IP-Address` with the IP address of the Proxmox host or backup server.

### Set Up a Cron Job

To automatically run the backup scripts at a specified time, you can set up a cron job.

1. Open the crontab configuration file:
   ```bash
   crontab -e
   ```

2. Add an entry for the backup script. For example, to run the script daily at 2:00 AM:
   ```bash
   0 2 * * * /path/to/zentraler_SKRIPT.sh >> /path/to/log/zentraler_sync.log 2>&1
   ```

   Replace `/path/to/zentraler_SKRIPT.sh` with the actual path of the script and `/path/to/log/zentraler_sync.log` with the path to the log file.

## Usage

1. **Customize the Scripts**:
   - Replace placeholders for usernames, IP addresses, and directories with your specific values.
   - Define the list of Proxmox hosts and backup servers along with their IP addresses in the script.

2. **Run the Scripts**:
   - Ensure the scripts are executable: `chmod +x scriptname.sh`
   - Run the scripts: `./scriptname.sh`

3. **Verify Backups**:
   - Verify the created backups in the specified directory.

4. **Restoration**:
   - Choose the backup date and the host or backup server for restoration.
   - Run the restoration script and follow the instructions.

## Note

Make sure to customize the scripts to your specific requirements before use. Replace placeholders for IP addresses, usernames, and directories with your specific information.

We hope these scripts simplify and automate your Proxmox backup and restoration processes. If you have any questions or suggestions for improvement, we look forward to your feedback!

---

# Proxmox Host & Backup Server Backup Sync Skripte

Willkommen im Proxmox Host Backup Sync GitHub Repository! Dieses Repository enthält eine Sammlung von Bash-Skripten, die entwickelt wurden, um die Sicherung und Wiederherstellung von Proxmox-Konfigurationen über mehrere Hosts und Backup-Server hinweg zu erleichtern. Die Skripte unterstützen sowohl das Synchronisieren von Konfigurationen aus `/etc/pve` als auch das gesamte `/etc`-Verzeichnis, um umfassende Backup- und Wiederherstellungsfunktionen zu gewährleisten. Die Skripte werden von einem zentralen PC bzw. einer VM ausgeführt und speichern die Konfigurationen in separaten Verzeichnissen für Hosts und Backup-Server.

## Funktionen

- **Konfigurationen sichern**: Synchronisieren Sie Konfigurationen von mehreren Proxmox-Hosts und Backup-Servern zu einem zentralen Backup-Speicherort.
- **Konfigurationen wiederherstellen**: Stellen Sie Konfigurationen aus dem zentralen Backup auf einem beliebigen Proxmox-Host oder Backup-Server wieder her.
- **Farbcodierte Ausgabe**: Klare und visuell unterschiedliche Ausgaben zur einfachen Nachverfolgung des Skriptfortschritts.
- **Ladeanimation**: Zeigt den Fortschritt der Backup- und Wiederherstellungsvorgänge an.

## Übersicht der Skripte

### zentraler_sync.sh

Dieses Skript synchronisiert die Proxmox-Konfigurationen aus dem Verzeichnis `/etc/pve` udn `/etc/proxmox-backup` von mehreren Hosts und Backup-Servern zu einem zentralen Backup-Verzeichnis.

- **Hosts und IP-Adressen definieren**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Adresse-1"
      ["Host-Name-2"]="IP-Adresse-2"
      ...
  )
  ```
  Ersetzen Sie die Platzhalter `Host-Name-1`, `IP-Adresse-1`, etc. durch Ihre spezifischen Host-Namen und IP-Adressen.

- **Backup-Server und IP-Adressen definieren**:
  ```bash
  declare

 -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Adresse-1"
      ["Backup-Server-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts/"  # Lokales Backup-Verzeichnis für Hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers/"  # Lokales Backup-Verzeichnis für Backup-Server
  ```

### zentraler_sync_etc.sh

Dieses Skript synchronisiert das gesamte Verzeichnis `/etc` von mehreren Hosts und Backup-Servern zu einem zentralen Backup-Verzeichnis.

- **Hosts und IP-Adressen definieren**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Adresse-1"
      ["Host-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Server und IP-Adressen definieren**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Adresse-1"
      ["Backup-Server-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts-etc/"  # Lokales Backup-Verzeichnis für Hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers-etc/"  # Lokales Backup-Verzeichnis für Backup-Server
  ```

### zentraler_restore.sh

Dieses Skript ermöglicht die Wiederherstellung von Proxmox-Konfigurationen aus dem zentralen Backup-Verzeichnis auf einem bestimmten Host oder Backup-Server. Benutzer können das gewünschte Backup-Datum und den Host oder Backup-Server zur Wiederherstellung auswählen.

- **Hosts und IP-Adressen definieren**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Adresse-1"
      ["Host-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Server und IP-Adressen definieren**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Adresse-1"
      ["Backup-Server-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts/"  # Lokales Backup-Verzeichnis für Hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers/"  # Lokales Backup-Verzeichnis für Backup-Server
  ```

### zentraler_restore_etc.sh

Ähnlich wie `zentraler_restore.sh`, ermöglicht dieses Skript jedoch die Wiederherstellung des gesamten `/etc`-Verzeichnisses aus dem zentralen Backup-Verzeichnis auf einem bestimmten Host oder Backup-Server.

- **Hosts und IP-Adressen definieren**:
  ```bash
  declare -A HOSTS=(
      ["Host-Name-1"]="IP-Adresse-1"
      ["Host-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Server und IP-Adressen definieren**:
  ```bash
  declare -A BACKUP_SERVERS=(
      ["Backup-Server-1"]="IP-Adresse-1"
      ["Backup-Server-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  HOST_LOCAL_DIR="/backup/proxmox-hosts-etc/"  # Lokales Backup-Verzeichnis für Hosts
  SERVER_LOCAL_DIR="/backup/proxmox-servers-etc/"  # Lokales Backup-Verzeichnis für Backup-Server
  ```

## SSH-Schlüssel einrichten

Um die Skripte ohne Eingabe eines Passworts auszuführen, müssen Sie SSH-Schlüssel für die Verbindung zwischen dem zentralen Server und den Proxmox-Hosts und Backup-Servern einrichten.

### SSH-Schlüssel generieren

1. Erstellen Sie ein SSH-Schlüsselpaar auf dem zentralen Server:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "Ihr Kommentar"
   ```
   Folgen Sie den Anweisungen und speichern Sie den Schlüssel im Standardpfad (`~/.ssh/id_rsa`).

2. Kopieren Sie den öffentlichen Schlüssel auf jeden Proxmox-Host und Backup-Server:
   ```bash
   ssh-copy-id root@IP-Adresse
   ```
   Ersetzen Sie `IP-Adresse` durch die IP-Adresse des Proxmox-Hosts oder Backup-Servers.

### Cronjob einrichten

Um die Backup-Skripte automatisch zu einem bestimmten Zeitpunkt auszuführen, können Sie einen Cronjob einrichten.

1. Öffnen Sie die Crontab-Konfigurationsdatei:
   ```bash
   crontab -e
   ```

2. Fügen Sie einen Eintrag für das Backup-Skript hinzu. Zum Beispiel, um das Skript täglich um 2:00 Uhr morgens auszuführen:
   ```bash
   0 2 * * * /pfad/zu/zentraler_sync.sh >> /pfad/zu/log/zentraler_sync.log 2>&1
   ```

   Ersetzen Sie `/pfad/zu/zentraler_sync.sh` durch den tatsächlichen Pfad des Skripts und `/pfad/zu/log/zentraler_sync.log` durch den Pfad zur Logdatei.

## Verwendung

1. **Anpassung der Skripte**:
   - Ersetzen Sie Platzhalter für Benutzernamen, IP-Adressen und Verzeichnisse durch Ihre spezifischen Werte.
   - Definieren Sie die Liste der Proxmox-Hosts und Backup-Server sowie deren IP-Adressen im Skript.

2. **Ausführung der Skripte**:
   - Stellen Sie sicher, dass die Skripte ausführbar sind: `chmod +x skriptname.sh`
   - Führen Sie die Skripte aus: `./skriptname.sh`

3. **Überprüfung der Backups**:
   - Verifizieren Sie die erstellten Backups im angegebenen Verzeichnis.

4. **Wiederherstellung**:
   - Wählen Sie das Datum des Backups und den Host oder Backup-Server zur Wiederherstellung aus.
   - Führen Sie das Wiederherstellungsskript aus und folgen Sie den Anweisungen.

## Hinweis

Stellen Sie sicher, dass Sie die Skripte vor der Verwendung an Ihre spezifischen Anforderungen anpassen. Ersetzen Sie Platzhalter für IP-Adressen, Benutzernamen und Verzeichnisse durch Ihre spezifischen Informationen.

Wir hoffen, dass diese Skripte Ihre Backup- und Wiederherstellungsprozesse für Proxmox vereinfachen und automatisieren. Bei Fragen oder Verbesserungsvorschlägen freuen wir uns über Ihr Feedback!

