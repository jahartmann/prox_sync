# Proxmox Host Backup Sync Scripts

Willkommen im Proxmox Host Backup Sync GitHub Repository! Dieses Repository enthält eine Sammlung von Bash-Skripten, die entwickelt wurden, um die Sicherung und Wiederherstellung von Proxmox-Konfigurationen über mehrere Nodes hinweg zu erleichtern. Die Skripte unterstützen sowohl das Synchronisieren von Konfigurationen aus `/etc/pve` als auch das gesamte `/etc`-Verzeichnis, um umfassende Backup- und Wiederherstellungsfunktionen zu gewährleisten.
Die Skripte werden von einem zentralen PC bzw eienr VM ausgeführt und speichern die configs.

## Funktionen

- **Konfigurationen sichern**: Synchronisieren Sie Konfigurationen von mehreren Proxmox-Nodes zu einem zentralen Backup-Speicherort.
- **Konfigurationen wiederherstellen**: Stellen Sie Konfigurationen aus dem zentralen Backup auf einem beliebigen Proxmox-Node wieder her.
- **Farbcodierte Ausgabe**: Klare und visuell unterschiedliche Ausgaben zur einfachen Nachverfolgung des Skriptfortschritts.
- **Ladeanimation**: Zeigt den Fortschritt der Backup- und Wiederherstellungsvorgänge an.

## Übersicht der Skripte

### zentraler_sync.sh

Dieses Skript synchronisiert die Proxmox-Konfigurationen aus dem Verzeichnis `/etc/pve` von mehreren Nodes zu einem zentralen Backup-Verzeichnis.

- **Nodes und IP-Adressen definieren**:
  ```bash
  declare -A NODES=(
      ["Node-Name-1"]="IP-Adresse-1"
      ["Node-Name-2"]="IP-Adresse-2"
      ...
  )
  ```
  Ersetzen Sie die Platzhalter `Node-Name-1`, `IP-Adresse-1`, etc. durch Ihre spezifischen Node-Namen und IP-Adressen.

- **Backup-Verzeichnis festlegen**:
  ```bash
  LOCAL_DIR="/backup/proxmox-configs/"  # Lokales Backup-Verzeichnis
  ```

### zentraler_sync_etc.sh

Dieses Skript synchronisiert das gesamte Verzeichnis `/etc` von mehreren Nodes zu einem zentralen Backup-Verzeichnis.

- **Nodes und IP-Adressen definieren**:
  ```bash
  declare -A NODES=(
      ["Node-Name-1"]="IP-Adresse-1"
      ["Node-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  LOCAL_DIR="/backup/proxmox-configs-etc/"  # Lokales Backup-Verzeichnis
  ```

### zentraler_restore.sh

Dieses Skript ermöglicht die Wiederherstellung von Proxmox-Konfigurationen aus dem zentralen Backup-Verzeichnis auf einem bestimmten Node. Benutzer können das gewünschte Backup-Datum und den Node zur Wiederherstellung auswählen.

- **Nodes und IP-Adressen definieren**:
  ```bash
  declare -A NODES=(
      ["Node-Name-1"]="IP-Adresse-1"
      ["Node-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  LOCAL_DIR="/backup/proxmox-configs/"  # Lokales Backup-Verzeichnis
  ```

### zentraler_restore_etc.sh

Ähnlich wie `zentraler_restore.sh`, ermöglicht dieses Skript jedoch die Wiederherstellung des gesamten `/etc`-Verzeichnisses aus dem zentralen Backup-Verzeichnis auf einem bestimmten Node.

- **Nodes und IP-Adressen definieren**:
  ```bash
  declare -A NODES=(
      ["Node-Name-1"]="IP-Adresse-1"
      ["Node-Name-2"]="IP-Adresse-2"
      ...
  )
  ```

- **Backup-Verzeichnis festlegen**:
  ```bash
  LOCAL_DIR="/backup/proxmox-configs-etc/"  # Lokales Backup-Verzeichnis
  ```

## SSH-Schlüssel einrichten

Um die Skripte ohne Eingabe eines Passworts auszuführen, müssen Sie SSH-Schlüssel für die Verbindung zwischen dem Backup-Server und den Proxmox-Nodes einrichten.

### SSH-Schlüssel generieren

1. Erstellen Sie ein SSH-Schlüsselpaar auf dem Backup-Server:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "Ihr Kommentar"
   ```
   Folgen Sie den Anweisungen und speichern Sie den Schlüssel im Standardpfad (`~/.ssh/id_rsa`).

2. Kopieren Sie den öffentlichen Schlüssel auf jeden Proxmox-Node:
   ```bash
   ssh-copy-id root@IP-Adresse
   ```
   Ersetzen Sie `IP-Adresse` durch die IP-Adresse des Proxmox-Nodes.

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
   - Definieren Sie die Liste der Proxmox-Nodes und deren IP-Adressen im Skript.

2. **Ausführung der Skripte**:
   - Stellen Sie sicher, dass die Skripte ausführbar sind: `chmod +x skriptname.sh`
   - Führen Sie die Skripte aus: `./skriptname.sh`

3. **Überprüfung der Backups**:
   - Verifizieren Sie die erstellten Backups im angegebenen Verzeichnis.

4. **Wiederherstellung**:
   - Wählen Sie das Datum des Backups und den Node zur Wiederherstellung aus.
   - Führen Sie das Wiederherstellungsskript aus und folgen Sie den Anweisungen.

## Hinweis

Stellen Sie sicher, dass Sie die Skripte vor der Verwendung an Ihre spezifischen Anforderungen anpassen. Ersetzen Sie Platzhalter für IP-Adressen, Benutzernamen und Verzeichnisse durch Ihre spezifischen Informationen.

Wir hoffen, dass diese Skripte Ihre Backup- und Wiederherstellungsprozesse für Proxmox vereinfachen und automatisieren. Bei Fragen oder Verbesserungsvorschlägen freuen wir uns über Ihr Feedback!

---


