#!/bin/bash
###################################################################################################
#                                                                                                 #
#                                     ###  ###  #   # # #   #                                     #
#                                    #   # #  # ## ## # ##  #                                     #
#                                    #   # #  # # # # # # # #                                     #
#                                    ##### #  # #   # # #  ##                                     #
#                                    #   # ###  #   # # #   #                                     #
#                                                                                                 #
###################################################################################################

#──────────────────────────────────────────────────────────────────────────────────────────────────
. ~/.sources.sh; import --controls --events --parts
#──────────────────────────────────────────────────────────────────────────────────────────────────

# INFO:
#
# DONE: ✓

# Operates according to this schema:
#
#   INIT -> MELD -> { functions activity } => admin flag -> MELD -> ...
#        -> FUSE -> { functions integrity } => stop/go -> FUSE -> ...
#        -> FRAME -> { units => state declarations => read states } -> FRAME -> ...
#        -> GUARD ->
#        -> CHAIN -> { chains file => activity pattern correction } -> CHAIN -> ...
#        -> SETUP ->

# STATES: TYPING, CODING, TALKING, WORKING, PLAYING, READING, RESTING, BROWSING, WATCHING,
#         RUMBLING, PRESENT

#--------------------------------------------------------------------------------------------------
frame() #
{       #

    __framing__()   #
    {
        [ -e ${___CON_STA___}/${1} ] && eval "${1}=True" || eval "${1}=False";
    }

    STATES=()

    for UNIT in ${REBUNTU}/units/*
    do
        if cat ${UNIT} | grep -qo 'touch ${___CON_STA___}/'
        then
            local TEMP=$(cat "${UNIT}" | grep 'touch ${___CON_STA___}/*');
            local STATE="${TEMP##*/}"
            STATES+=( "${STATE}" )
            __framing__ "${STATE}"

        fi
    done
}

#--------------------------------------------------------------------------------------------------
guard() #
{       #
    true
}

#--------------------------------------------------------------------------------------------------
chain() #
{       #

    # Chain syntax:     unit-unit-unit-unit

    # For any given chain:
    #
    # (1) if at least one chained unit is enabled,
    #     the function will attempt to enable the other units composing the chain
    #
    # (2) if the attempt is not successfull for all units,
    #     the function will attemp to disable all units contained in the chain

    local CHAINS="${REBUNTU}/system/config/chains.conf"
    local CHAINS_BACKUP="${REBUNTU}/system/config/chains_bkp.conf"

    if [ "$(settings chained)" = "True" ]
    then
        cp ${CHAINS} ${CHAINS_BACKUP}
        sed -i "s:-: :g" ${CHAINS}

        while read chain
        do
            declare ACTIVATE
            declare DEACTIVATE

            for CELL in ${chain}                                                # Ǝ enabled?
            do
                if [ "$(activity --enabled ${CELL})" = "True" ]
                then
                    local ACTIVATE=True
                fi
            done

            if [ "${ACTIVATE}" = "True" ]
            then
                for CELL in ${chain}
                do
                    if [ "$(activity --enabled ${CELL})" != "True" ]            # Ǝ enabled,
                    then                                                        # enable Ɐ
                        register --enable ${CELL}

                        if [ "$(activity --enabled ${___UNIT___})" != "True" ]
                        then
                            error admin-chain-unit-enable ${CELL}
                        fi
                    fi
                done
            fi

            for CELL in ${chain}
            do
                if [ "$(activity --enabled ${CELL})" != "True" ]                # Ɐ enabled?
                then
                    if [ "$(activity --running core)" = "True" ]
                    then
                        if [ "$(activity --on ${CELL})" != "True" ]
                        then
                            local DEACTIVATE=True
                            error admin-chain-unit-activation ${CELL}
                        fi
                    else
                        local DEACTIVATE=True
                        error admin-chain-unit-enable-all ${chain}
                    fi
                fi
            done

            if [ "${DEACTIVATE}" = "True" ]
            then
                for CELL in ${chain}
                do
                    if [ "$(activity --enabled ${CELL})" = "True" ]             # not Ɐ enabled,
                    then                                                        # disable Ɐ
                        register --disable ${CELL}

                        if [ "$(activity --enabled ${___UNIT___})" = "True" ]
                        then
                            error admin-chain-unit-disable ${CELL}
                        fi
                    fi
                done
            fi

        done < ${CHAINS}

        rm ${CHAINS}
        mv ${CHAINS_BACKUP} ${CHAINS}
    fi
}

#--------------------------------------------------------------------------------------------------
setup() #
{       #
    true
}

#--------------------------------------------------------------------------------------------------
fuse()  # core's exam function counterpart
{       # responsible for the runtime integrality

    sleep 1                                                     # functions catch-up

    if [ "$(activity --running admin)" != "True" ]              # check the main processor flag
    then                                                        # if's is missing,
        for FUNC in $@                                          # shut down all running functions
        do
            register --down "${FUNC}"
        done

        if [ "$(activity --running meld)" = "True" ]
        then
            register --down meld
        fi

        if [ "$(activity --running fuse)" = "True" ]
        then
            register --down fuse
        fi
    else
        for FUNC in $@
        do
            if [ "$(activity --running ${FUNC})" != "True" ]    # check all partial activity flags
            then                                                # if any flag is missing,
                for F in $@                                     # attempt to shut down
                do                                              # all the other
                    if [ "${FUNC}" != "${F}" ]
                    then
                        register --down ${F}
                    fi
                done
            fi
        done
    fi
}

#--------------------------------------------------------------------------------------------------
meld()  # core's modified 'join' function
{       # responsible for the main flag's presence

    sleep 0.1                                                   # functions catch-up

    for FUNC in $@                                              # component's functions
    do                                                          # activity check
        if [ "$(activity --running ${FUNC})" != "True" ]
        then
            local COMPLETE=False
        fi
    done

    if [ "${COMPLETE}" = "False" ]                              # main activity flag creation
    then                                                        # upon complete function
        register --down admin                                   # activation
    else
        register --runs admin
    fi
}

#--------------------------------------------------------------------------------------------------
init()  # initialization function
{       # called by the loader's request,
        # if passed through the 'imports filter'

    for FUNC in $@
    do
        if [ "$(activity --running ${FUNC})" != "True" ]
        then
            # runner ${FUNC} &

            if [ "${FUNC}" = "fuse" ]
            then
                shift 1
                runner fuse ${@} &
            elif [ "${FUNC}" = "meld" ]
            then
                shift 1
                runner meld ${@} &
            else
                runner ${FUNC} &
            fi
        fi
    done

    sleep 0.1

    for FUNC in $@
    do
        if [ "$(activity --running ${FUNC})" != "True" ]
        then
            return 1
        fi
    done

    return 0
}

#--------------------------------------------------------------------------------------------------
if [ "$(controls --imported)" = "True" ]
then
    if [ "$(definitions --sourced)" = "True" ]
    then
        if [ "$(events --imported)" = "True" ]
        then
            if [ "$(language --sourced)" = "True" ]
            then
                if [ "$(activity --running admin)" != "True" ]
                then
                    init meld fuse frame guard chain setup

                    if [ "$(activity --running admin)" = "True" ]
                    then
                        exit 0  # return status for the loader
                    else
                        exit 1
                    fi
                else
                    exit 0
                fi
            else
                exit 2
            fi
        else
            exit 2
        fi
    else
        exit 2
    fi
else
    exit 2
fi
