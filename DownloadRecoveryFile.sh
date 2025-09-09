#!/bin/bash

# I make this script publicly available under the term "public domain software."
# You can do whatever you want with it because it is truly free—unlike so-called "free" software with conditions, like the GNU licenses and other similar nonsense.
# If you're so eager to talk about freedom, then make it truly free.
# You don't have to accept any terms of use or license to use or modify it, because it comes with no CopyLeft.

# ----------
# NiPeGun's script to download the ChromeOS ZIP recovery file
#
# Remote execution (may require sudo privileges):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/DownloadRecoveryFile.sh | bash
#
# Remote execution as root (for systems without sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/DownloadRecoveryFile.sh | sed 's-sudo--g' | bash
#
# Download and edit the file directly in nano:
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/DownloadRecoveryFile.sh | nano -

# Set the -zip file URL
  vFileURL="https://dl.google.com/chromeos-flex/images/latest.bin.zip"

# Get the name of the downloads folder
  vDownloadFolderPath=$(xdg-user-dir DOWNLOAD)

# Downlaod
  echo ""
  echo "  Downloading .zip file..."
  echo ""
  # Check if curl package is installed. If not, install ir.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  The curl package is not installed. Starting its installation...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install curl
      echo ""
    fi
  cd /tmp
  curl -L $vFileURL -o $vDownloadFolderPath/chromeos-flex.zip --progress-bar

# Extract
  echo ""
  echo "  Extracting .bin file from .zip..."
  echo ""
  # Check if unzip package is installed. If not, install ir.
    if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  The unzip package is not installed. Starting its installation...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install unzip
      echo ""
    fi
  mkdir /tmp/ChromeOSFlex/ 2> /dev/null
  unzip -o $vDownloadFolderPath/chromeos-flex.zip -d $vDownloadFolderPath/ && rm -vf $vDownloadFolderPath/chromeos-flex.zip
  # Rebane .bin file
    find $vDownloadFolderPath/ -name chromeos*.bin -type f -exec mv -vf {} $vDownloadFolderPath/chromeos-flex-latest.bin \;
