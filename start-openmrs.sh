#!/bin/bash -aeu
#	This Source Code Form is subject to the terms of the Mozilla Public License,
#	v. 2.0. If a copy of the MPL was not distributed with this file, You can
#	obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
#	the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
#
#	Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
#	graphic logo is a trademark of OpenMRS Inc.
echo "Checking for Docker..."

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. Installing Docker..."
    echo "This requires an internet connection and may prompt for your password."

    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        echo "Installing Docker Desktop via Homebrew..."
        brew install --cask docker
        if [ $? -ne 0 ]; then
            echo "Failed to install Docker. Please install it manually from https://www.docker.com/products/docker-desktop/"
            exit 1
        fi
        echo "Starting Docker Desktop..."
        open /Applications/Docker.app
        sleep 30
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Installing Docker for Linux..."
        sudo apt-get update
        sudo apt-get install -y docker.io docker-compose
        sudo systemctl start docker
        sudo systemctl enable docker
        if [ $? -ne 0 ]; then
            echo "Failed to install Docker. Please install it manually: https://docs.docker.com/engine/install/"
            exit 1
        fi
        sudo usermod -aG docker $USER
        echo "You may need to log out and back in for Docker permissions to take effect."
    else
        echo "Unsupported OS. Please install Docker manually from https://www.docker.com/"
        exit 1
    fi
fi

# Ensure Docker is running
echo "Ensuring Docker is running..."
if ! docker ps >/dev/null 2>&1; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Starting Docker Desktop..."
        open /Applications/Docker.app
        sleep 30
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Starting Docker service..."
        sudo systemctl start docker
    fi
    if ! docker ps >/dev/null 2>&1; then
        echo "Docker failed to start. Please ensure it’s running and try again."
        exit 1
    fi
fi

# Display version selection menu
echo "Select an OpenMRS version to run:"
echo "1) Platform 2.6.14"
echo "2) Platform 2.7.0"
echo "3) Reference Application 2.12.0"
echo "4) Reference Application 2.13.0"
echo "5) O3 3.2.1"
echo "6) O3 3.1.1"
read -p "Enter your choice (1-6): " choice

# Set OPENMRS_IMAGE based on choice
case $choice in
    1) OPENMRS_IMAGE="openmrs/openmrs-core:2.6.14" ;;
    2) OPENMRS_IMAGE="openmrs/openmrs-core:2.7.0" ;;
    3) OPENMRS_IMAGE="openmrs/openmrs-reference-application-distro:2.12.0" ;;
    4) OPENMRS_IMAGE="openmrs/openmrs-reference-application-distro:2.13.0" ;;
    5) OPENMRS_IMAGE="openmrs/openmrs-reference-application-3-frontend:3.2.1" ;;
    6) OPENMRS_IMAGE="openmrs/openmrs-reference-application-3-frontend:3.1.1" ;;
    *) echo "Invalid choice. Defaulting to Reference Application UAT."
       OPENMRS_IMAGE="openmrs/openmrs-reference-application-distro:uat" ;;
esac

# Start OpenMRS with selected image
echo "Starting OpenMRS with $OPENMRS_IMAGE..."
OPENMRS_IMAGE=$OPENMRS_IMAGE docker-compose up