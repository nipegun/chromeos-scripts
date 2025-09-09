#!/bin/bash

# I make this script publicly available under the term "public domain software."
# You can do whatever you want with it because it is truly free—unlike so-called "free" software with conditions, like the GNU licenses and other similar nonsense.
# If you're so eager to talk about freedom, then make it truly free.
# You don't have to accept any terms of use or license to use or modify it, because it comes with no CopyLeft.

# ----------
# NiPeGun's script to copy data from ChromeOS Flex recovery file mounted partitions
#
# Remote execution (may require sudo privileges):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mounted-CopyFiles.sh | bash
#
# Remote execution as root (for systems without sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mounted-CopyFiles.sh | sed 's-sudo--g' | bash
#
# Download and edit the file directly in nano:
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mounted-CopyFiles.sh | nano -

# Get the name of the downloads folder
  vDownloadFolderPath=$(xdg-user-dir DOWNLOAD)

# Set the .bin mounted partitions folder
  vChromeOSFlexPartitionsFolder="/ChromeOSFlexRecovery/Partitions" # Do not add final /

# Get the EFI Partition folder
  for vIndice in $(seq -w 01 99); do
    vNroConCeros=$(printf "%02d" $((vIndice + 1)))
    if [[ -d "$vChromeOSFlexPartitionsFolder/$vNroConCeros/efi" && -d "$vChromeOSFlexPartitionsFolder/$vNroConCeros/syslinux" ]]; then
      vEFIPartitionFolder="$vChromeOSFlexPartitionsFolder/$vNroConCeros/"
      break
    fi
  done
  echo ""
  echo "  ChromeOSFlex EFI partition folder mounted in:"
  echo ""
  echo "    $vEFIPartitionFolder"
  echo ""

# Get the root Partition folder
  for vIndice in $(seq -w 01 99); do
    vNroConCeros=$(printf "%02d" $((vIndice + 1)))
    if [[ -d "$vChromeOSFlexPartitionsFolder/$vNroConCeros/home" && -d "$vChromeOSFlexPartitionsFolder/$vNroConCeros/root" ]]; then
      vRootPartitionFolder="$vChromeOSFlexPartitionsFolder/$vNroConCeros/"
      break
    fi
  done
  echo ""
  echo "  ChromeOSFlex root partition folder mounted in:"
  echo ""
  echo "    $vRootPartitionFolder"
  echo ""

# Copy files
  # Remove previous files
    sudo rm -rf /ChromeOSFlexHD/
  # efi
    sudo mkdir -p /ChromeOSFlexHD/fat32/
    sudo cp -a "$vEFIPartitionFolder". /ChromeOSFlexHD/fat32/
  # ext4
    sudo mkdir -p /ChromeOSFlexHD/ext4/
    sudo cp -a "$vRootPartitionFolder". /ChromeOSFlexHD/ext4/

