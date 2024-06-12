#!/usr/bin/env bash
  #==============================================
  # Project: DEVILUTIONX_INSTALLER4LINUX
  # Author:  ConzZah / 2024
  # Last Modification: 12.06.2024 / 20:16 [v0.1]
  #==============================================
cd /home/$USER
### setting variables #######################################################
detected_architecture=$(uname -m)
i386="devilutionx-linux-i386"
x86_64="devilutionx-linux-x86_64"
i386_latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-i386.tar.xz"
x86_x64_latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-x86_64.tar.xz"
DIABDAT_MPQ="https://archive.org/download/diabdat_202406/DIABDAT.MPQ"
dl_msg="DOWNLOADING $detected_architecture VERSION OF DEVILUTIONX..."
extract_msg="EXTRACTING DEVILUTIONX..."
dlx_done="DEVILUTIONX DOWNLOADED TO: /home/$USER."
###########################################################################
function main {
c1="########################"
echo "$c1"; echo " DevilutionX Installer"; echo "$c1"
install_dependencies && detect_architecture;
}
#install_dependencies
function install_dependencies {
echo ""; echo "INSTALLING DEPENDENCIES FOR DEVOLUTIONX..."; echo ""
sudo apt install -y libsdl2-2.0-0 libsdl2-image-2.0-0 >/dev/null 2>&1
echo "DEPENDENCIES INSTALLED."
}
# detect_architecture
function detect_architecture {
if [[ "$detected_architecture" == "i386" ]] || [[ "$detected_architecture" == "i686" ]]; then echo ""; dl_32-bit_devilutionx; fi 
if [[ "$detected_architecture" == "x86_64" ]]; then echo ""; dl_64-bit_devilutionx; fi 
}
# dl_32-bit_devilutionx
function dl_32-bit_devilutionx {
echo "$dl_msg"; mkdir "$i386-latest"; cd "$i386-latest"
wget -q --show-progress "$i386_latest_release"
echo ""; echo "$extract_msg"; echo ""
tar -xf "$i386.tar.xz"
rm "$i386.tar.xz"
echo "$dlx_done"
dl_DIABDAT_MPQ
}
# dl_64-bit_devilutionx
function dl_64-bit_devilutionx {
echo "$dl_msg"; mkdir "$x86_64-latest"; cd "$x86_64-latest"
wget -q --show-progress "$x86_x64_latest_release"
echo ""; echo "$extract_msg"; echo ""
tar -xf "$x86_64.tar.xz"
rm "$x86_64.tar.xz"
echo "$dlx_done"
dl_DIABDAT_MPQ
}
#dl_DIABDAT_MPQ
function dl_DIABDAT_MPQ {
echo ""; echo "DOWNLOADING DIABDAT.MPQ FROM ARCHIVE.ORG"; echo ""
wget -q --show-progress "$DIABDAT_MPQ"
echo ""; echo "DONE DOWNLOADING DIABDAT.MPQ"
echo ""; echo "HAVE FUN PLAYING :D"
echo "[ PRESS ANY KEY TO EXIT ]"; read -n 1 -s; exit
}
main
