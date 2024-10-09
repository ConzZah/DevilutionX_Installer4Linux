#!/usr/bin/env bash
  #=================================================
  # Project: DEVILUTIONX_INSTALLER4LINUX
  # Author:  ConzZah / 2024
  # Last Modification: 09.10.2024 / 05:42  [v0.3]
  #=================================================
### setting variables #######################################################
dl_path="/home/$USER"; curl="curl -# -L -o" 
mpqpath="/home/$USER/.local/share/diasurgical/devilution"
mpqpath_flatpak="/home/$USER/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution"
flatpak_present=$(type -p flatpak > /dev/null && flatpak list|grep -o DevilutionX|head -n 1)
architecture=$(uname -m); if [[ "$architecture" =~ ^(i486|i586|i686)$ ]]; then architecture="i386"; fi
DX="devilutionx-linux-$architecture"; latest_release="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-linux-$architecture.tar.xz" # <-- $DX and $latest_release will point to systems architecture
DIABDAT_MPQ="https://archive.org/download/diabdat_202406/DIABDAT.MPQ"; hellfire_7z="https://archive.org/download/diabdat_202406/hellfire.7z"
deps_install_msg="INSTALLING DEPENDENCIES.."; deps_done="DEPENDENCIES INSTALLED."; dl_msg="DOWNLOADING DEVILUTIONX.. ($architecture)"
i=0; bin=("apt" "apk" "dnf" "yum" "pacman" "zypper" "brew"); pm=""
while [ $i -lt ${#bin[@]} ]; do
if type -p "${bin[$i]}" > /dev/null; then pm="${bin[$i]}"; break; fi
((i++))
done
function _init {
if [[ ! "$architecture" =~ ^(i386|x86_64|aarch64)$ ]]; then echo ""; echo "$architecture NOT SUPPORTED"; quit; fi # <-- if $architecture doesn't match i386 / x86_64 / aarch64, print message & quit 
c1="########################"; cd "$dl_path"; echo "$c1"; echo " DevilutionX Installer"; echo "$c1"; echo ""
if [[ "$pm" == "apk" ]]; then choose4alpine; quit; fi
if [[ "$pm" == "apt" ]]; then deps_deb; install_deb; quit; fi
if [[ "$pm" == "dnf" || "$pm" == "yum" ]]; then deps_rpm; install_rpm; quit; fi
if [[ "$pm" == "pacman" || "$pm" == "zypper" ]]; then dl_devilutionx; quit; fi
}
# deps_deb
function deps_deb { echo "$deps_install_msg"; sudo apt install -y libsdl2-2.0-0 libsdl2-image-2.0-0 curl 7zip >/dev/null 2>&1; echo ""; echo "$deps_done"; dl_devilutionx ;}
# deps_rpm
function deps_rpm { echo "$deps_install_msg"; sudo "$pm" install -y SDL2 curl 7zip >/dev/null 2>&1; echo ""; echo "$deps_done"; dl_devilutionx ;}
# dl_devilutionx
function dl_devilutionx {
echo ""; echo "$dl_msg"; echo ""; mkdir -p "$DX-latest"; cd "$DX-latest"; rm "$DX.tar.xz" >/dev/null 2>&1
$curl "$DX.tar.xz" "$latest_release"; tar -xf "$DX.tar.xz"; rm "$DX.tar.xz" ;}
# install_flatpak
function install_flatpak { ! type -p flatpak > /dev/null && echo "" && echo "FLATPAK NOT FOUND ON SYSTEM" && quit; echo ""; flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; flatpak install flathub org.diasurgical.DevilutionX ;}
# install_deb
function install_deb { echo ""; echo "INSTALLING DEB PACKAGE.."; echo ""; sudo dpkg -i devilutionx.deb ;}
# install_rpm
function install_rpm { echo ""; echo "INSTALLING RPM PACKAGE.."; echo ""; sudo "$pm" install devilutionx.rpm ;}
# choose4alpine
function choose4alpine {
echo "ALPINE DETECTED"; echo ""; echo "1) INSTALL FLATPAK"; echo "2) BUILD FROM SOURCE"; echo ""
read -r choose4alpine; case $choose4alpine in
1) doas apk add flatpak sdl2 pipewire wireplumber pipewire-pulse pipewire-alsa curl 7zip; doas addgroup $USER audio; install_flatpak; quit;;
2) Build4Alpine; quit;;
*) clear; _init
esac
}
# Build4Alpine ( NOTE: built in zerotier multiplayer isn't working, so i disabled it. ) 
function Build4Alpine { echo ""; echo "INSTALLING BUILD DEPENDENCIES.."
doas apk update; doas apk add cmake build-base sdl2-dev sdl2_image-dev pkgconf libbz2 bzip2-dev zlib-dev libjpeg-turbo-dev libpng-dev libsodium-dev gtest-dev benchmark-dev gettext-dev fmt-dev xz curl 7zip
src_xz="devilutionx-src.tar.xz"; src_link="https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-src.tar.xz"
echo "GETTING LATEST SOURCE.."; echo ""; cd "$dl_path"; $curl "$src_xz" "$src_link"; tar -xf "$src_xz"; rm "$src_xz"; cd devilutionx-src-*
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DDISABLE_ZERO_TIER=ON
cmake --build build -j $(getconf _NPROCESSORS_ONLN)
cd build; doas make install; quit
}
function dl_mpq {
echo ""; echo "CHECKING FOR INSTALLED GAMEFILES.."; echo ""; mkdir -p "$mpqpath" && cd "$mpqpath"
_diabdat () { rm DIABDAT.MPQ >/dev/null 2>&1; touch .x; echo "DOWNLOADING DIABDAT.MPQ FROM ARCHIVE.ORG"; echo ""; $curl DIABDAT.MPQ "$DIABDAT_MPQ" && rm .x; echo ""; echo "DONE DOWNLOADING DIABDAT.MPQ" ;}
_hellfire () { rm hellfire.7z >/dev/null 2>&1; echo ""; echo "DOWNLOADING hellfire.7z FROM ARCHIVE.ORG"; echo ""; $curl hellfire.7z "$hellfire_7z"; echo ""; echo "EXTRACTING hellfire.7z"; 7z x hellfire.7z -y >/dev/null 2>&1 && rm hellfire.7z >/dev/null 2>&1 ;}
[ -f "DIABDAT.MPQ" ] && [ ! -f ".x" ] && echo "--> DIABLO FOUND!" || _diabdat 
[ -f "hellfire.mpq" ] && echo "--> HELLFIRE FOUND!" || _hellfire; quit
}
# quit
function quit { echo ""; echo "[ PRESS ANY KEY TO EXIT ]"; echo ""; read -n 1 -s; exit ;} 
# args:
if [[ "$1" == "-build4alpine" ]]; then [[ "$pm" == "apk" ]] && Build4Alpine || echo "" && echo "YOU DON'T SEEM TO BE RUNNING ALPINE." && quit; fi
if [[ "$1" == "-flatpak" ]]; then [ -z "$flatpak_present" ] && install_flatpak && quit || [ ! -z "$flatpak_present" ] && echo "" && echo "FLATPAK VERSION ALREADY INSTALLED." && quit || quit; fi
if [[ "$1" == "-mpq" ]]; then [ -z "$flatpak_present" ] && dl_mpq || [ ! -z "$flatpak_present" ] && echo "" && echo "FLATPAK DETECTED." && mpqpath=$mpqpath_flatpak && dl_mpq; fi # <-- if flatpak version is present, change $mpqpath
if [[ "$1" == "-help" ]]; then echo ""; echo "AVAILABLE ARGS:"; echo ""; echo "-mpq"; echo "-flatpak"; echo "-build4alpine"; echo ""; exit; fi
_init
