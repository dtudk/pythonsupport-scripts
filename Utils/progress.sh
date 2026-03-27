#!/usr/bin/bash

progress() {
    local msg=$1
    shift

    local log_file=${PROGRESS_LOG_FILE:-progress.log}
    local tmp_file fifo
    tmp_file=$(mktemp) || return 1
    fifo=$(mktemp -u) || { rm -f "$tmp_file"; return 1; }
    mkfifo "$fifo" || { rm -f "$tmp_file"; return 1; }

    exec 4>/dev/tty 2>/dev/null || exec 4>&1

    cleanup() {
        rm -f "$tmp_file" "$fifo"
        tput rmcup >&4 2>/dev/null || true
        tput cnorm >&4 2>/dev/null || true
    }
    trap cleanup EXIT TERM HUP

    tput smcup >&4 2>/dev/null || true
    tput civis >&4 2>/dev/null || true

    {
        "$@" >"$fifo" 2>&1
    } &
    local cmd_pid=$!

    {
        while IFS= read -r line || [[ -n $line ]]; do
            printf '%s\n' "$line" >>"$tmp_file"
            printf '%s\n' "$line" >>"$log_file"
        done <"$fifo"
    } &
    local reader_pid=$!

    local spin='-\|/' i=0

    while kill -0 "$cmd_pid" 2>/dev/null; do
        printf '\e[H\e[2J' >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        tail -n 5 "$tmp_file" 2>/dev/null >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        printf ' [%c] %s\n' "${spin:i++%${#spin}:1}" "$msg" >&4
        sleep 0.1
    done

    wait "$cmd_pid"
    local status=$?

    wait "$reader_pid" 2>/dev/null || true

    tput rmcup >&4 2>/dev/null || true
    tput cnorm >&4 2>/dev/null || true

    trap - EXIT INT TERM HUP

    if (( status != 0 )); then
        printf '✖ failed (%d)\n' "$status"
    else
        printf '✓ done\n'
    fi

    return "$status"
}

output1() {
    echo 1; sleep 1
    echo 2; sleep 1
    echo 3; sleep 1
    echo 4; sleep 1
    echo 5; sleep 1
    echo 6; sleep 1
    return 0
}

progress "something is happening..." output1
