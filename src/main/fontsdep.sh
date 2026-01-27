#!/bin/bash


# ==============================================================================
# Program name: fontsdep.sh
# 
# Copyright (c) 2026 Neruthes.
# 
# This script is released under the GNU GPL 2.0 license.
# It is a very stand-alone program so you may safely put it inside
# another project which has a different licensing scheme, as long as
# this notice is retained here at the top of the script.
# ==============================================================================






cat >/dev/null << EOFEOFEOF
[MICRO DOCUMENTATION]

Workflow when running this script:

- Get config from package.json or somewhere else.
- Create directories.
- Resolve list of font files.
- Skip some existing fonts files or download new ones.
EOFEOFEOF





# =====================================================================
# Stage: Startup initialization
# =====================================================================
function _die() {
    echo "[FATAL] $2"
    exit "$1"
}
function check_bin () {
    if ! command -v "$1" >/dev/null; then
        die 1 "CANNOT FIND $1"
    fi
}
check_bin jq
check_bin wget


function action__install_all() {
# =====================================================================
# Stage: Get config
# =====================================================================

### Currently only supports package.json
[[ ! -e package.json ]] && _die 2 "Cannot find 'package.json' !"

config_fontsdir="$(jq -r    .fontsdep.dest      package.json)"
[[ "$config_fontsdir" == null ]] && config_fontsdir=_fontsdir
echo "config_fontsdir=$config_fontsdir"

config_fontslist="$(jq -r   .fontsdep.list[]    package.json)"
[[ "$config_fontslist" == null ]] || [[ -z "$config_fontslist" ]] && _die 3 "Fonts list not configured!"

### TODO: Configure cache days


function _reolve_font_url () {
    input_url="$1"
    item_ns="$(cut -d: -f1 <<< "$input_url")"
    item_path="$(cut -d: -f2- <<< "$input_url")"
    calculated_prefix=NULL
    case $item_ns in
        CTAN )
            # calculated_prefix=https://mirrors.tuna.tsinghua.edu.cn/CTAN/fonts/
            calculated_prefix=https://mirrors.ctan.org/fonts/
            ;;
    esac
    case $calculated_prefix in
        NULL )
            return 1
            ;;
        * )
            echo "$calculated_prefix$item_path"
            return 0
            ;;
    esac
}


# =====================================================================
# Stage: Download fonts
# =====================================================================
function _decider_skip_download_task() {
    ### If file is new enough, return 0, else return 1
    local local_path="$1"
    if [[ ! -f "$local_path" ]]; then
        return 1
    fi
    if find "$local_path" -mtime -7 | grep -q .; then
        return 0
    else
        return 1
    fi
}
function _action_fetch_font() {
    line="$1"
    _reolve_font_url "$line" || _die 3 "Cannot resolve namespace '$line' !" 
    remote_url="$(_reolve_font_url "$line")"
    item_name_hash="$(sha256sum <<< "$line" | cut -c1-8)"
    item_basename="$(basename "$remote_url")"
    local_path="$config_fontsdir/${item_name_hash}-${item_basename}"
    if _decider_skip_download_task "$local_path"; then
        echo "[INFO] Skipping '$local_path' for it is still very new"
        return 0
    fi
    echo "Fetching '$remote_url' ..."
    echo "local_path=$local_path"
    curl --location --retry 40 --retry-max-time 60 --retry-all-errors -f "$remote_url" > "$local_path" || _die 4 "Failed downloading '$remote_url' !"

}
while read -r line; do
    mkdir -p "$config_fontsdir"
    _action_fetch_font "$line"
done <<< "$config_fontslist"

}








### Main
case "$1" in
    self_update | u )
        if [[ "$(realpath "$0")" == "$PWD/fontsdep.sh" ]]; then
            echo "Attempting to self_update ..."
            curl --retry 20 https://raw.githubusercontent.com/neruthes/fontsdep/refs/heads/master/src/main/fontsdep.sh > fontsdep.sh.tmp
            ### Detect this UUID to ensure successful download
            if grep ea5a57c4-4417-41c9-a83b-1e914587a50f fontsdep.sh.tmp; then
                (mv fontsdep.sh.tmp fontsdep.sh)
                exit 0
            fi
        fi
        ;;
    install | i | '' )
        action__install_all
        ;;
esac

