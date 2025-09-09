#!/bin/bash

# I make this script publicly available under the term "public domain software."
# You can do whatever you want with it because it is truly free—unlike so-called "free" software with conditions, like the GNU licenses and other similar nonsense.
# If you're so eager to talk about freedom, then make it truly free.
# You don't have to accept any terms of use or license to use or modify it, because it comes with no CopyLeft.

# ----------
# NiPeGun's script to mount all partitions in the ChromeOS Flex recovery file
#
# Remote execution (may require sudo privileges):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mount.sh | bash
#
# Remote execution as root (for systems without sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mount.sh | sed 's-sudo--g' | bash
#
# Download and edit the file directly in nano:
#   curl -sL https://raw.githubusercontent.com/nipegun/chromeos-scripts/refs/heads/main/RecoveryFile-Partitions-Mount.sh | nano -

# Get the name of the downloads folder
  vDownloadFolderPath=$(xdg-user-dir DOWNLOAD)

# Get the recovery file path
  vRecoveryFilePath="$vDownloadFolderPath"/chromeos-flex-latest.bin

# Definir fecha de ejecución del script
  cFechaDelRecovery=$(date +a%Ym%md%d@%T)

# Get the cluster size
  # Comprobar si el paquete sleuthkit está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s sleuthkit 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete sleuthkit no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install sleuthkit
      echo ""
    fi
  vBytesPerSector=$(mmls "$vRecoveryFilePath" | grep ector | grep - | cut -d'-' -f1 | sed 's- -\n-g' | grep ^[0-9])
  echo -e "\n" && echo "  Se calcularán offsets finales para tamaño de sector de $vBytesPerSector bytes..." && echo -e "\n"
    # Crear un array con los offsets de incio de cada partición
      aOffsetsDeInicio=()
      # Comprobar si el paquete fdisk está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s fdisk 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete fdisk no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install fdisk
          echo ""
        fi
      for vOffset in $(sudo fdisk -l -o Device,Start "$vRecoveryFilePath" | grep ^/ | rev | cut -d' ' -f1 | rev); do
        aOffsetsDeInicio+=("$vOffset")
      done

    # Multiplicar el valor de cada campo del array x el tamaño de bloque
      for vNroOffsetSimple in "${aOffsetsDeInicio[@]}"; do
        echo "  Multiplicando por $vBytesPerSector el offset $vNroOffsetSimple"
        vOffsetMultiplicado=$((vNroOffsetSimple * $vBytesPerSector))
        aNuevosOffsets+=("$vOffsetMultiplicado")
      done
      echo ""

    # Crear la carpeta del Recovery y montar las particiones como sólo lectura
      # Comprobar si el paquete util-linux está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s util-linux 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete util-linux no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install util-linux
          echo ""
        fi
      for vIndice in "${!aNuevosOffsets[@]}"; do
        vNroConCeros=$(printf "%02d" $((vIndice + 1)))
        sudo mkdir -p "/Recoverys/$cFechaDelRecovery/Imagen/Particiones/$vNroConCeros"
        vDispositivoLoopLibre=$(sudo losetup -f)
        sudo losetup -f -o "${aNuevosOffsets[vIndice]}" "$vRecoveryFilePath" && \
        echo -e "\n  Partición del offset ${aNuevosOffsets[vIndice]} asignada a $vDispositivoLoopLibre."
        sudo mount -o ro "$vDispositivoLoopLibre" "/Recoverys/$cFechaDelRecovery/Imagen/Particiones/$vNroConCeros" && \
        echo -e "\n    $vDispositivoLoopLibre montado en /Recoverys/$cFechaDelRecovery/Imagen/Particiones/$vNroConCeros.\n"
      done
      echo ""
