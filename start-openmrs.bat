::	This Source Code Form is subject to the terms of the Mozilla Public License,
::	v. 2.0. If a copy of the MPL was not distributed with this file, You can
::	obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
::	the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
::	Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
::	graphic logo is a trademark of OpenMRS Inc.
@echo off
echo Checking for Docker...

:: Check if Docker is installed
docker --version >nul 2>&1
if %ERROR LEVEL% NEQ 0 (
    echo Docker is not installed. Installing Docker Desktop...
    echo This requires administrative privileges and an internet connection.

    :: Check if Chocolatey is installed
    choco --version >nul 2>&1
    if %ERROR LEVEL% NEQ 0 (
        echo Installing Chocolatey first...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope CurrentUser; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"
    )

    :: Install Docker Desktop via Chocolatey
    echo Installing Docker Desktop...
    choco install docker-desktop -y
    if %ERROR LEVEL% NEQ 0 (
        echo Failed to install Docker Desktop. Please install it manually from https://www.docker.com/products/docker-desktop/
        pause
        exit /b 1
    )

    echo Docker Desktop installed. Please restart your computer if prompted, then run this script again.
    pause
    exit /b 0
)

:: Ensure Docker service is running
echo Ensuring Docker is running...
docker ps >nul 2>&1
if %ERROR LEVEL% NEQ 0 (
    echo Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    timeout /t 30 >nul
    docker ps >nul 2>&1
    if %ERROR LEVEL% NEQ 0 (
        echo Docker failed to start. Please ensure Docker Desktop is running and try again.
        pause
        exit /b 1
    )
)

:: Display version selection menu
echo Select an OpenMRS version to run:
echo 1) Platform 2.6.14
echo 2) Platform 2.7.0
echo 3) Reference Application 2.12.0
echo 4) Reference Application 2.13.0
echo 5) O3 3.0.0-beta.20
echo 6) O3 3.0.0-SNAPSHOT
set /p choice="Enter your choice (1-6): "

:: Set OPENMRS_IMAGE based on choice
if "%choice%"=="1" set "OPENMRS_IMAGE=openmrs/openmrs-core:2.6.14"
if "%choice%"=="2" set "OPENMRS_IMAGE=openmrs/openmrs-core:2.7.0"
if "%choice%"=="3" set "OPENMRS_IMAGE=openmrs/openmrs-reference-application-distro:2.12.0"
if "%choice%"=="4" set "OPENMRS_IMAGE=openmrs/openmrs-reference-application-distro:2.13.0"
if "%choice%"=="5" set "OPENMRS_IMAGE=openmrs/openmrs-distro-referenceapplication:3.0.0-beta.20"
if "%choice%"=="6" set "OPENMRS_IMAGE=openmrs/openmrs-distro-referenceapplication:3.0.0-SNAPSHOT"
if not defined OPENMRS_IMAGE (
    echo Invalid choice. Defaulting to Reference Application UAT.
    set "OPENMRS_IMAGE=openmrs/openmrs-reference-application-distro:uat"
)

:: Start OpenMRS with selected image
echo Starting OpenMRS with %OPENMRS_IMAGE%...
set "OPENMRS_IMAGE=%OPENMRS_IMAGE%" docker-compose up
pause