# OpenMRS Standalone-Run

Run OpenMRS with one click using Docker.

## Requirements
- Internet connection (for first-time setup if Docker isn’t installed).
- Administrative privileges (to install Docker if needed).

## How to Use
1. Download and unzip `openmrs-standalone-run.zip`.
2. Double-click `start-openmrs.bat` (Windows) or `start-openmrs.sh` (MacOS/Linux).
3. 
   **For Mac users**: Open a terminal in the unzipped folder and run the following command to make the script executable:
   ```bash
   chmod +x start-openmrs.sh
   chmod +x stop-openmrs.sh
3. If Docker isn’t installed, the script will attempt to install it (follow prompts).
4. Select an OpenMRS version from the menu:
    - 1) Platform 2.6.14
    - 2) Platform 2.7.0
    - 3) Reference Application 2.12.0
    - 4) Reference Application 2.13.0
    - 5) O3 3.0.0-beta.20
    - 6) O3 3.0.0-SNAPSHOT
5. Wait for OpenMRS to start (first run may take a few minutes to download images).
6. Open your browser and go to `http://localhost:8080/openmrs`.
7. Log in with `admin/Admin123` (default credentials).
8. To stop, press `Ctrl+C` in the terminal or run `stop-openmrs.bat`/`stop-openmrs.sh`.

## Notes
- Windows: May require a restart after Docker installation.
- MacOS/Linux: May prompt for your password to install Docker.
- Ensure enough disk space for Docker images (~2-3 GB).
- For a fresh start, delete the `mysql-data` and `openmrs-data` folders (advanced users).