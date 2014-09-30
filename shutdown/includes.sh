#!/bin/bash

if [[ ! $FILES_INCLUDED ]]; then
    FILES_INCLUDED=1
    FILEDIR=$(dirname ${BASH_SOURCE[0]})

    EXIT=0
    STATUS=""

    . $FILEDIR/tput_colors.inc.sh
    . $FILEDIR/functions.inc.sh
fi
