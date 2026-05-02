#!/usr/bin/env bash
# The MIT License (MIT)
#
# Copyright © 2026 Stephen G. Tuggy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ====================================
# @file   : bootstrap-on-linux.sh
# @brief  : installs dependencies for building boost_log_python_poc on Linux
# @usage  : sudo script/bootstrap-on-linux.sh 1 (to update all installed
#           packages on the system in the process)
#     or  : sudo script/bootstrap-on-linux.sh 0 (to skip updating, and
#           just install the new packages that are needed)
# @param  : just one parameter, either a 1 or a 0, to indicate whether or not to
#           UPDATE_ALL_SYSTEM_PACKAGES
# ====================================

set -e

echo "------------------------------------------"
echo "--- bootstrap-on-linux.sh | 2026-05-01 ---"
echo "------------------------------------------"

UPDATE_ALL_SYSTEM_PACKAGES="$1"

if [ -f /etc/os-release ]
then
  OS_RELEASE_LOCATION="/etc/os-release"
elif [ -f /usr/lib/os-release ]
then
  OS_RELEASE_LOCATION="/usr/lib/os-release"
else
  echo "os-release file not found; unable to continue"
  exit 1
fi
LINUX_ID=$(grep ^ID= $OS_RELEASE_LOCATION | sed 's/^ID=//' | tr -d '"\n')
echo "LINUX_ID = ${LINUX_ID}"
LINUX_CODENAME=$(grep ^VERSION_CODENAME= $OS_RELEASE_LOCATION | sed 's/^VERSION_CODENAME=//' | tr -d '"\n')
echo "LINUX_CODENAME = ${LINUX_CODENAME}"
LINUX_VERSION_ID=$(grep ^VERSION_ID= $OS_RELEASE_LOCATION | sed 's/^VERSION_ID=//' | tr -d '"\n')
echo "LINUX_VERSION_ID = ${LINUX_VERSION_ID}"

function bootstrapOnDebian()
{
  apt-get update

  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    apt-get -qy upgrade
  fi

  case "$LINUX_CODENAME" in
    "trixie"|"bookworm")
      apt-get -qy install \
                      git \
                      cmake \
                      build-essential \
                      libboost-log-dev \
                      libboost-python-dev \
                      clang \
                      lsb-release \
                      ninja-build
      ;;
    "bullseye"|"buster"|"stretch")
      echo "Sorry, Debian ${LINUX_CODENAME} is no longer supported"
      exit 2
      ;;
    *)
      echo "Sorry, this version of Debian is unsupported"
      exit 2
      ;;
  esac
}

function bootstrapOnUbuntu()
{
  apt-get update

  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    apt-get -qy upgrade
  fi

  case "$LINUX_CODENAME" in
    "resolute"|"questing"|"noble"|"jammy")
      apt-get -qy install \
                      git \
                      cmake \
                      build-essential \
                      libboost-log-dev \
                      libboost-python-dev \
                      clang \
                      lsb-release \
                      ninja-build
      ;;
    "plucky"|"hirsute"|"impish"|"focal"|"bionic"|"xenial")
        echo "Sorry, Ubuntu ${LINUX_CODENAME} is no longer supported"
        exit 2
        ;;
    *)
      echo "Sorry, this version of Ubuntu is unsupported"
      exit 2
      ;;
  esac
}

function bootstrapOnPopOS ()
{
  apt-get update

  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    apt-get -qy upgrade
  fi

  case "$LINUX_CODENAME" in
    "noble"|"jammy")
      apt-get -qy install \
                      git \
                      cmake \
                      build-essential \
                      libboost-log-dev \
                      libboost-python-dev \
                      clang \
                      lsb-release \
                      ninja-build
      ;;
    *)
      echo "Sorry, this version of Pop! OS is not currently supported"
      exit 2
      ;;
  esac
}

function bootstrapOnLinuxMint ()
{
  apt-get update

  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    apt-get -qy upgrade
  fi

  case "$LINUX_CODENAME" in
    "alfa"|"zena"|"zara"|"wilma"|"virginia"|"victoria"|"vera"|"vanessa"|"ulyana")
      apt-get -qy install \
                      git \
                      cmake \
                      build-essential \
                      libboost-log-dev \
                      libboost-python-dev \
                      clang \
                      lsb-release \
                      ninja-build
      ;;
    *)
      echo "This version of Linux Mint is not directly supported. You may be able to use the corresponding Ubuntu installation package"
      exit 2
      ;;
  esac
}

function bootstrapOnOpenSuseLeap ()
{
  case "${LINUX_VERSION_ID}" in
    "15.4"|"15.5"|"15.6")
      zypper --non-interactive install -y \
                              libboost_log1_75_0-devel \
                              libboost_python-py3-1_75_0-devel \
                              libboost_thread1_75_0-devel \
                              cmake \
                              gcc-c++ \
                              python3-devel \
                              git \
                              rpm-build \
                              clang \
                              ninja
      ;;
    "16.0")
      zypper --non-interactive install -y \
                              libboost_log1_86_0-devel \
                              libboost_python-py3-1_86_0-devel \
                              libboost_thread1_86_0-devel \
                              cmake \
                              gcc-c++ \
                              python3-devel \
                              git \
                              rpm-build \
                              clang \
                              ninja
      ;;
    *)
      echo "Sorry, this version of openSUSE Leap is unsupported"
      exit 2
      ;;
  esac
}

function bootstrapOnFedora ()
{
  export fedoraVersion=${LINUX_VERSION_ID}
  export fedoraMaxSupportedVersion=44
  export fedoraMinSupportedVersion=42
  if [ ${fedoraVersion} -gt ${fedoraMaxSupportedVersion} ]
  then
    echo "Fedora Version ${fedoraVersion} is not yet supported. Pull requests welcome"
  elif [ ${fedoraVersion} -ge ${fedoraMinSupportedVersion} ]
  then
    if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
    then
      dnf -y upgrade --refresh
    fi
    dnf install -y \
                        git \
                        cmake \
                        gcc-c++ \
                        rpm-build \
                        make \
                        boost-devel \
                        python3-devel \
                        rpm-build \
                        clang \
                        ninja
  else
    echo "Sorry, Fedora ${LINUX_VERSION_ID} is no longer supported"
    exit 2
  fi
}

function bootstrapOnRedHat ()
{
  case "${LINUX_VERSION_ID}" in
    "9.5")
      if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
      then
        dnf -y upgrade --refresh
      fi
      dnf -y install dnf-plugins-core
      dnf config-manager --set-enabled crb
      dnf config-manager --set-enabled devel
      dnf -y install epel-release
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    "9.6"|"9.7")
      if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
      then
        dnf -y upgrade --refresh
      fi
      dnf -y install dnf-plugins-core
      dnf config-manager --set-enabled crb
      dnf config-manager --set-enabled devel
      dnf -y install epel-release
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    "10.0"|"10.1")
      dnf -y upgrade --refresh
      dnf -y install 'dnf-command(config-manager)'
      dnf -y config-manager --set-enabled crb
      dnf -y config-manager --set-enabled devel
      dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    *)
      echo "Sorry, this version of Red Hat is unsupported"
      exit 2
      ;;
  esac
}

function bootstrapOnRockyLinux ()
{
  case "${LINUX_VERSION_ID}" in
    "9.5")
      if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
      then
        dnf -y upgrade --refresh
      fi
      dnf -y install dnf-plugins-core
      dnf config-manager --set-enabled crb
      dnf config-manager --set-enabled devel
      dnf -y install epel-release
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    "9.6")
      if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
      then
        dnf -y upgrade --refresh
      fi
      dnf -y install dnf-plugins-core
      dnf config-manager --set-enabled crb
      dnf config-manager --set-enabled devel
      dnf -y install epel-release
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    "10.0"|"10.1")
      dnf -y upgrade --refresh
      dnf -y install 'dnf-command(config-manager)'
      dnf -y config-manager --set-enabled crb
      dnf -y config-manager --set-enabled devel
      dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
      dnf -y update
      dnf -y install \
                          git \
                          cmake \
                          boost-devel \
                          boost-python3-devel \
                          gcc-c++ \
                          python3-devel \
                          rpm-build \
                          make \
                          clang \
                          ninja-build
      ;;
    *)
      echo "Sorry, this version of Rocky Linux is unsupported"
      exit 2
      ;;
  esac
}

function bootstrapOnManjaro ()
{
  pacman -Sy --noconfirm archlinux-keyring manjaro-keyring

  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    pacman -Syyu --refresh --noconfirm
  fi

  pacman -Sy --noconfirm cmake \
                   boost \
                   clang \
                   gcc \
                   gcc-libs \
                   python \
                   git \
                   make \
                   ninja
}

function bootstrapOnFuntoo ()
{
  ego sync
  dispatch-conf
  # enable `autounmask-write` so that USE flags
  # change in the image appropriately
  USE="-libffi -userland_GNU" emerge --autounmask-write \
        cmake \
        boost \
        python \
        git \
        make
}

function bootstrapOnArch ()
{
  if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
  then
    pacman -Syyu --refresh --noconfirm
  fi

  # NOTE: Arch requires GCC 12 right now
  # also installing latest GCC.
  pacman -Sy --noconfirm \
        base-devel \
        cmake \
        boost \
        gcc \
        gcc12 \
        python \
        git \
        make \
        ninja
}

case "${LINUX_ID}" in
  "debian")
    bootstrapOnDebian
    ;;
  "ubuntu")
    bootstrapOnUbuntu
    ;;
  "pop")
    bootstrapOnPopOS
    ;;
  "linuxmint")
    bootstrapOnLinuxMint
    ;;
  "opensuse-leap")
    bootstrapOnOpenSuseLeap
    ;;
  "fedora")
    bootstrapOnFedora
    ;;
  "rhel")
    bootstrapOnRedHat
    ;;
  "redhat")
    bootstrapOnRedHat
    ;;
  "rocky")
    bootstrapOnRockyLinux
    ;;
  "manjaro")
    bootstrapOnManjaro
    ;;
  "funtoo")
    bootstrapOnFuntoo
    ;;
  "arch")
    bootstrapOnArch
    ;;
  *)
    echo "Sorry, unrecognized/unsupported Linux distribution"
    exit 2
    ;;
esac

mkdir -pv /usr/local/src/boost_log_python_poc

echo "Bootstrapping finished!"
