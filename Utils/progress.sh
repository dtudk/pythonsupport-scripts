#!/usr/bin/bash

# Params:
# - message: str
# - estimated time: int
# - command: str list
progress() {
    local msg=$1 mins=$2 log_file="/tmp/dtu_log.txt" start_line=1
    shift 2

    if [[ -f "$log_file" ]]; then
        start_line=$(($(wc -l <"$log_file")+1))
    else
        touch "$log_file" || return 1
    fi

    echo "[DTULOG]: $msg ($(date))" >> "$log_file"
    exec 4>/dev/tty 2>/dev/null || exec 4>&1

    cleanup() {
        tput rmcup >&4 2>/dev/null || true
        tput cnorm >&4 2>/dev/null || true
    }
    trap cleanup EXIT TERM HUP

    tput smcup >&4 2>/dev/null || true
    tput civis >&4 2>/dev/null || true

    "$@" >>"$log_file" 2>&1 &
    local cmd_pid=$!
    local spin='-\|/' i=0

    while kill -0 "$cmd_pid" 2>/dev/null; do
        printf '\e[H\e[2J' >&4
        printf '  \033[1m%s\033[0m\n' "DTU installation in progress." >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        tail -n +"$((start_line + 1))" "$log_file" 2>/dev/null | tail -n 5 >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        printf '  \033[1m[%c] %s\033[0m\n' "${spin:i++%${#spin}:1}" "$msg" >&4
        printf '      %s\n' \
            "Please do not interrupt this script - it may take up to $mins minutes." >&4
        # Bump up sleep, this is too frequent, 0.2-0.4 should be fine, no need to
        # put unneeded stress on CPU's
        sleep 0.1
    done

    wait "$cmd_pid"
    local status=$?

    cleanup
    trap - EXIT TERM HUP
    echo "$msg"

    if (( status != 0 )); then
        echo  "[DTULOG]: failure ($status)" >> "$log_file"
        printf ' ┗━ \033[1;31m%s\033[00m (error code %d).\n' Failure $status
        echo "    Please contact us and provide the file '$log_file'."
    else
        echo  "[DTULOG]: success" >> "$log_file"
        printf ' ┗━ \033[1;32m%s\033[0m\n' 'Success!'
    fi

    return "$status"
}

output0() {
    echo 1; sleep 1
    echo 2; sleep 1
    echo 3; sleep 1
    echo 4; sleep 1
    echo 5; sleep 1
    echo 6; sleep 1
    echo done >&2; sleep 0.5
    return 0
}

output1() {
    echo 1; sleep 0.5
    echo 2; sleep 0.5
    echo 3; sleep 0.5
    echo 4; sleep 0.5
    echo 5; sleep 0.5
    echo 6; sleep 0.5
    echo done >&2; sleep 0.5
    return 1
}

progress "Step 1/1: Installing XYZ" 15 output0
