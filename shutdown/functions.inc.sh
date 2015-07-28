#!/bin/bash

# checks if the script is running on the crowbar node
function crowbar_inst_check {
    if [ ! -f /opt/dell/crowbar_framework/.crowbar-installed-ok ]; then
        echo "Please run this script on the crowbar node."
        exit 1
    fi
}

# compares the expected exit code with the real exit code from the executed command
function check_exit_code {
    if [[ $1 -eq $2 ]]; then
        STATUS="${GREEN}done${RESET}"
    else
        STATUS="${RED}error${RESET}"
    fi
}

# detect error
function detect_error {
    if [[ $1 != "0" ]]; then
        echo "[Error] Script exited with exit code $1"
        exit $1
    fi
}
