#!/usr/bin/env bash
  #=================================================
  # Project: DEVILUTIONX_INSTALLER4LINUX
  # Author:  ConzZah / 2024
  # Last Modification: 09.09.2024 / 14:56  [v0.4]
  #=================================================
### setting variables #######################################################
dl_path="/home/$USER"
devilutionxpath="/home/$USER/.local/share/diasurgical/devilution"
devilutionxpath__flatpak="/home/$USER/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution"
detected_architecture=$(uname -m)
is_alpine=$(uname -v|grep -o -w Alpine)
is_debian=$(uname -v|grep -o -w Debian)
i386="devilutionx-linux-i386"
x86_64="devilutionx-linux-x86_64"
aarch64="devilutionx-linux-aarch64"
deps_install_msg="INSTALLING DEPENDENCIES.."
deps_done="DEPENDENCIES INSTALLED."
i386_latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-i386.tar.xz"
x86_x64_latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-x86_64.tar.xz"
aarch64_latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-aarch64.tar.xz"
DIABDAT_MPQ="https://archive.org/download/diabdat_202406/DIABDAT.MPQ"
hellfire_7z="https://archive.org/download/diabdat_202406/hellfire.7z"
dl_msg="DOWNLOADING $detected_architecture VERSION OF DEVILUTIONX..."
extract_msg="EXTRACTING DEVILUTIONX..."
dlx_done="DEVILUTIONX EXTRACTED TO: $dl_path."
_os="" # <-- leave empty
###########################################################################
function _init {
c1="########################"
cd "$dl_path"; echo "$c1"; echo " DevilutionX Installer"; echo "$c1"
detect_os
}
# detect_os
function detect_os {
if [[ "$is_alpine" == "Alpine" ]]; then _os=$is_alpine; devilutionxpath=$devilutionxpath__flatpak; echo ""; install_dependencies_4Alpine; fi
if [[ "$is_debian" == "Debian" ]]; then _os=$is_debian; echo ""; install_dependencies; fi
if [[ "$_os" == "" ]]; then echo ""; install_dependencies; fi
}
# install_dependencies
function install_dependencies {
echo "OS: $_os $detected_architecture"; echo ""; echo "$deps_install_msg"; echo ""
sudo apt install -y libsdl2-2.0-0 libsdl2-image-2.0-0 7zip >/dev/null 2>&1
echo ""; echo "$deps_done"
_install
}
# _install
function _install {
if [[ "$detected_architecture" == "i386" ]] || [[ "$detected_architecture" == "i686" ]]; then echo ""; dl_i386_devilutionx; fi 
if [[ "$detected_architecture" == "x86_64" ]]; then echo ""; dl_x86_64_devilutionx; fi 
if [[ "$detected_architecture" == "aarch64" ]]; then echo ""; dl_aarch64_devilutionx; fi 
}
# dl_i386_devilutionx
function dl_i386_devilutionx {
echo "$dl_msg"; echo ""; mkdir -p "$i386-latest"; cd "$i386-latest"
wget -q --show-progress "$i386_latest_release"; echo ""; echo "$extract_msg"; echo ""; tar -xf "$i386.tar.xz"; rm "$i386.tar.xz"; echo "$dlx_done"
sudo dpkg -i devilutionx.deb
quit
}
# dl_x86_64_devilutionx
function dl_x86_64_devilutionx {
echo "$dl_msg"; echo ""; mkdir -p "$x86_64-latest"; cd "$x86_64-latest"
wget -q --show-progress "$x86_x64_latest_release"; echo ""; echo "$extract_msg"; echo ""; tar -xf "$x86_64.tar.xz"; rm "$x86_64.tar.xz"; echo "$dlx_done" 
sudo dpkg -i devilutionx.deb
quit
}
# dl_aarch64_devilutionx
function dl_aarch64_devilutionx {
echo "$dl_msg"; echo ""; mkdir -p "$aarch64-latest"; cd "$aarch64-latest"
wget -q --show-progress "$aarch64_latest_release"; echo ""; echo "$extract_msg"; echo ""; tar -xf "$aarch64.tar.xz"; rm "$aarch64.tar.xz"; echo "$dlx_done"
sudo dpkg -i devilutionx.deb
quit
}
# install_dependencies_4Alpine
function install_dependencies_4Alpine {
echo "OS: $_os $detected_architecture"; echo ""; echo "$deps_install_msg"; echo ""
doas apk add pipewire wireplumber pipewire-pulse pipewire-alsa xz 7zip wget flatpak && doas flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
doas addgroup $USER audio; echo ""; echo "$deps_done"
_install4Alpine
}
# _install4Alpine
function _install4Alpine {
echo ""; echo "INSTALLING DEVILUTIONX ON $_os $detected_architecture..."; doas flatpak install flathub org.diasurgical.DevilutionX -y
echo ""; echo "CREATING DESKTOP SHORTCUT..."; wget -q -O DevilutionXicon.png https://dl.flathub.org/media/org/diasurgical/DevilutionX/efffbabdc1197860961d876a90396475/icons/128x128/org.diasurgical.DevilutionX.png
doas mv DevilutionXicon.png /etc
_sc="DevilutionX.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=DevilutionX">>$_sc
echo "Comment=DevilutionX">>$_sc
echo "Exec=flatpak run org.diasurgical.DevilutionX">>$_sc
echo "Icon=/etc/DevilutionXicon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
quit
}
function dl_DIABDAT_MPQ { 
echo ""; echo "CHECKING FOR INSTALLED GAMEFILES.."
if [ ! -f "$devilutionxpath/x.txt" ]; then if [ -f "$devilutionxpath/DIABDAT.MPQ" ]; then echo ""; echo "FOUND DIABLO!"; echo ""; fi; fi; if [ -f "$devilutionxpath/hellfire.mpq" ]; then echo "FOUND HELLFIRE!"; fi 
if [ -f "$devilutionxpath/x.txt" ]; then rm $devilutionxpath/DIABDAT.MPQ >/dev/null 2>&1; fi; if [ ! -f "$devilutionxpath/DIABDAT.MPQ" ]; then mkdir -p $devilutionxpath; cd $devilutionxpath; touch x.txt
echo ""; echo "DOWNLOADING DIABDAT.MPQ FROM ARCHIVE.ORG"; echo ""
wget -q --show-progress "$DIABDAT_MPQ"; echo ""; echo "DONE DOWNLOADING DIABDAT.MPQ"; rm x.txt; fi
if [ ! -f "$devilutionxpath/hellfire.mpq" ]; then mkdir -p $devilutionxpath; cd $devilutionxpath
echo ""; echo "DOWNLOADING hellfire.7z FROM ARCHIVE.ORG"; echo ""; if [ -f "$devilutionxpath/hellfire.7z" ]; then rm hellfire.7z >/dev/null 2>&1; fi 
wget -q --show-progress "$hellfire_7z"; 7z x hellfire.7z && rm hellfire.7z >/dev/null 2>&1; fi
quit
}
function quit { echo ""; echo "HAVE FUN PLAYING :D"; echo ""; echo "[ PRESS ANY KEY TO EXIT ]"; read -n 1 -s; echo ""; exit ;} 
if [[ "$1" == "-mpq" ]]; then dl_DIABDAT_MPQ; fi
_init 
