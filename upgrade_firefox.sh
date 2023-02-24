#!/bin/bash

# Define the Firefox edition and installation directory
firefox_edition="firefox-beta"
firefox_dir="/opt/firefox"

# Check if Firefox is running
if pgrep firefox >/dev/null 2>&1; then
    echo "Firefox is running. Please close it before running this script."
    exit 1
fi

# Get the current version of Firefox
current=$(firefox -version | awk '/Mozilla Firefox/ {print $NF}')

# Check for newer version of Firefox
latest=$(curl -s "https://download.mozilla.org/?product=$firefox_edition-latest&os=linux64&lang=en-US" | grep -o 'firefox-.*tar' | cut -d '-' -f2- | sed 's/\.tar//')

if [ -z "$latest" ]; then
    echo "Unable to determine latest version of $firefox_edition."
    exit 1
elif [ "$latest" = "$current" ]; then
    echo "$firefox_edition is already up to date."
    exit 0
fi

# Download and extract newer version
echo "Downloading $firefox_edition $latest..."
curl -L --progress-bar --location "https://download.mozilla.org/?product=$firefox_edition-latest&os=linux64&lang=en-US" -o firefox.tar.bz2

echo "Extracting $firefox_edition $latest..."
sudo tar -C "$firefox_dir" -xvf firefox.tar.bz2 --strip-components=1

# Remove the downloaded archive
rm firefox.tar.bz2

echo "$firefox_edition $current has been installed. Starting Firefox..."
"$firefox_dir/firefox"
