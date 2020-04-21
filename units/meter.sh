#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# NAME: Meter
#
# TASK: Updates current microphone input level into a file.
#
# ZONE: measurement
#
# MODE: plain
#
# TYPE: simple
#
# DONE: ✓
#
#──────────────────────────────────────────────────────────────────────────────────────────────────
. ~/.sources.sh; import --calls --events --signals --states --objects
#──────────────────────────────────────────────────────────────────────────────────────────────────

main()
{
    LVLF=/tmp/level.wav
    LOUD=${___CON_VAR___}/loudness

    arecord --duration=1 --quiet $LVLF > /dev/null 2>&1;

    LOUDNESS=$(sox ${LVLF} -n stats 2>&1 | grep 'RMS lev dB' | awk '{print $4}';);
    # [ -e ${LVLF} ] && rm -f $LVLF

    if echo $LOUDNESS | grep -qo "[[:digit:]]"
    then
        LEVEL_INT=${LOUDNESS%.*}
    else
        LEVEL_INT="-99"
    fi

    echo $LEVEL_INT > ${___CON_VAR___}/loudness

    DATE="$(date +%d-%m-%Y)"

    [ -d /tmp/rebuntu/loundess ] || mkdir -p /tmp/rebuntu/loundess
    [ -e "/tmp/rebuntu/loundess/${DATE}" ] || touch "/tmp/rebuntu/loundess/${DATE}"

    if [ -e ${___CON_ION___}/meter ]
    then
        [ -e ${___CON_VAR___}/loudness ] && LOUD=$(cat ${___CON_VAR___}/loudness)
        echo "$(date +%H:%M:%S): ${LOUD}" >> "/tmp/rebuntu/loundess/${DATE}"
    fi
}

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || header --define && main

#-------------------------------------------------------------------------------------------------#
############|                                                                      |              #
########|   |                                                                  	   |              #
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
