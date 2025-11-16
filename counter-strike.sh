#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/tasksetter
source $controlfolder/device_info.txt

[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls
CUR_TTY=/dev/tty0

SCRIPTDIR="$(dirname "$0")"
PORTDIR="/$directory/ports/"
GAMEDIR="${PORTDIR}/Half-Life"
cd "$GAMEDIR"

# Grab text output...
$ESUDO chmod 666 $CUR_TTY
$ESUDO touch log.txt
$ESUDO chmod 666 log.txt
export TERM=linux
printf "\033c" > $CUR_TTY

# ---- LOAD COUNTER-STRIKE ----
RUNMOD="-game cstrike"

# Quick sanity check
if [[ ! -f "${GAMEDIR}/cstrike/liblist.gam" ]]; then
  echo "Missing cstrike files. Copy your 'cstrike' folder into: ${GAMEDIR}" > $CUR_TTY
  sleep 4
  printf "\033c" > $CUR_TTY
  $ESUDO systemctl restart oga_events &
  exit 1
fi

DEVICE_ARCH="${DEVICE_ARCH:-aarch64}"

$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# Add CS dll paths in addition to valve ones (safe if they don't exist)
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH:/usr/lib32:$GAMEDIR/valve/dlls:$GAMEDIR/valve/cl_dlls:$GAMEDIR/cstrike/dlls:$GAMEDIR/cstrike/cl_dlls"

$GPTOKEYB "xash3d.${DEVICE_ARCH}" &

# Optional: start on a map and fill with bots automatically (comment out if undesired)
# +map de_dust +maxplayers 10 +sv_lan 1 ensures a local server even without Wi-Fi
./xash3d.${DEVICE_ARCH} -ref gles2 -fullscreen -console $RUNMOD +map de_dust +maxplayers 10 +sv_lan 1 2>&1 | tee -a ./log.txt

$ESUDO kill -9 $(pidof gptokeyb)
unset LD_LIBRARY_PATH
unset SDL_GAMECONTROLLERCONFIG
$ESUDO systemctl restart oga_events &

# Disable console
printf "\033c" >> $CUR_TTY
