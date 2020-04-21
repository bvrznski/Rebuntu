#!/bin/bash
###################################################################################################
#                                                                                                 #
#                                      ###   ###  ###  ####                                       #
#                                     #   # #   # #  # #                                          #
#                                     #     #   # ##   ###                                        #
#                                     #   # #   # # #  #                                          #
#                                      ###   ###  #  # ####                                       #
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
#    INIT -> JOIN -> { functions activity } => core flag -> JOIN -> ...
#         -> EXAM -> { functions integrity } => stop/go -> EXAM -> ...
#         -> DUMP -> { units => flag inversion & clean } -> DUMP -> ...
#         -> LOOP >> { units } >>> MAIN >>> {  unit execution  } -> LOOP -> ...
#

#--------------------------------------------------------------------------------------------------
main()  # CENTRAL UNIT DAEMONIZATION FUNCTION - Initialized for each unit, loops it's execution,
{       #                                       modulates activation frequency

    # the most important function of the core, (if one can make such a distinction)
    # since it provides the main functionality of the core - script daemonization

    # dependent on six controller's directories:
    # - active:   indicates that the unit is 'on', and actively processing
    # - inactive: indicates thet the unit is 'on', but has entered the 'sleep' phase of the cycle
    # - enabled:  'initiatiory' activation flag, de facto triggers the launch of the daemon
    # - disabled: 'terminatory' inactivation flag, shuts down the daemon after completing the
    #             execution stream (simple units), or in between the processing stages at
    #             specified control flow checkpoints (extended units)
    # - on:       indicates that the unit has been activated
    # - off:      indicates that the unit is not active at all

    #---------------------------------------------------

    #   Legend:
    #
    #   - 'irrelevant'
    #   ✓ flag exist
    #   ✗ flag missing

    #   ENABLED DISABLED ON OFF ACTIVE INACTIVE
    #      ✓       ✗    ✗  ✓    ✗       ✗

    #   Daemon will stop for these flag configurations:
    #
    #   ENABLED DISABLED ON OFF ACTIVE INACTIVE
    #      ✓       ✓    -  -    -       -
    #      ✗       ✓    -  -    -       -
    #      ✗       ✗    -  -    -       -

    #---------------------------------------------------

    # Arguments for using such a 'primitive',
    # but practical solution for daemon control:

    # - in Linux 'everything is a file', so file path is, at least potentially,
    #                                    the most readily understood entity by
    #                                    the operaing systems's shell, there is

    # - filepaths are simple and somewhat 'final', regardless the path, relative or full
    #                                              each path leads to some resource,
    #                                              so the existence of the associated resource
    #                                              is one of the simplest and most reliable
    #                                              truth/false mappings i can think of

    # - files can be deleted 'offhand', as long as there's an access to the system shell or to any
    #                                   filesystem manager application, which has sufficient
    #                                   permissions to modify the file

    # - it's faster and less computationally expensive to 'read the value' of a boolean variable,
    #                                                  when defining a file's existence or it's
    #                                                  nonexistence as the truth value of this
    #                                                  variable, than reading it from within
    #                                                  the file

    # Disadvantages of the file-flag approach:

    # - no security at all (since this project is not heavily focused on security,
    #                       as it relies on the operating system's shell security
    #                       itself, and assumes that it has not been compromised )

    # - no readymade tool implementing the desired functionality (since it's simplicity is
    #                                                             it's essential quality )

    ___TARGET___="${1}"; ___UNIT___="${2}";

    if [ "$(activity --locked ${___UNIT___})" != "True" ]       # instance lock
    then
        register --lock ${___UNIT___}

        # 'enabled and off' filter
        if [ "$(activity --disabled ${___UNIT___})" = "False" ]     # 4 flags have been used
        then                                                        # instead of 2 in case
            if [ "$(activity --enabled ${___UNIT___})" = "True" ]   # the 'flag inversion'
            then                                                    # mechanism fails
                if [ "$(activity --on ${___UNIT___})" = "False" ]
                then
                    if [ "$(activity --off ${___UNIT___})" = "True" ]
                    then
                        register --on ${___UNIT___}

                        if [ "$(activity --on ${___UNIT___})" = "True" ]
                        then
                            sound --on

                            while true
                            do
                                if [ "$(activity --running core)" = "True" ]
                                then
                                    # 'enabled and on filter'
                                    if [ "$(activity --disabled ${___UNIT___})" = "False" ]
                                    then
                                        if [ "$(activity --enabled ${___UNIT___})" = "True" ]
                                        then
                                            if [ "$(activity --on ${___UNIT___})" = "True" ]
                                            then
                                                if [ "$(activity --off ${___UNIT___})" = "False" ]
                                                then

                                                    register --active ${___UNIT___}

                                                    #---------- unit activation section -----------
                                                    if [ "$(activity --activated ${___UNIT___})" = "True" ]
                                                    then
                                                        if [ "${___TARGET___##*.}" = "sh" ]
                                                        then
                                                            bash ${___TARGET___}
                                                        elif [ "${___TARGET___##*.}" = "py" ]
                                                        then
                                                            python3 ${___TARGET___}
                                                        fi
                                                    else
                                                        error core-main-active-flag-creation $2
                                                    fi
                                                    #----------------------------------------------
                                                    register --inactive ${___UNIT___}

                                                    if [ "$(activity --activated ${___UNIT___})" = "False" ]
                                                    then
                                                        frequency "${___UNIT___}"
                                                    else
                                                        error core-main-inactive-flag-creation $2

                                                        register --off ${___UNIT___}

                                                        if [ "$(activity --off ${___UNIT___})" = "True" ]
                                                        then
                                                            sound --off
                                                            break
                                                        else
                                                            error core-main-off-flag-creation $2
                                                            break

                                                fi; fi; fi;
                                            else
                                                break
                                            fi
                                        else
                                            register --unlock ${___UNIT___}
                                            break

                                        fi; fi;
                                else
                                    register --unlock ${___UNIT___}
                                    break

                                fi;
                            done;
        fi; fi; fi; fi; fi;
    else
        exit
    fi;
}

#--------------------------------------------------------------------------------------------------
loop()  # iterates over the unit's collective directory, and compares the controls against the
{       # current activity pattern for contained each unit, activating those units that meet the
        # criteria defined in the 'main' function

    for UNI in ${REBUNTU}/units/*
    do
        UNIT="${UNI##*/}"
        NAME="${UNIT%.*}"

        if [ "$(activity --disabled ${NAME})" = "False" ]
        then
            if [ "$(activity --enabled ${NAME})" = "True" ]
            then
                if [ "$(activity --on ${NAME})" = "False" ]
                then
                    if [ "$(activity --off ${NAME})" = "True" ]
                    then
                        main ${UNI} ${NAME} &
                        frequency "loop"
                    fi;
                fi;
            fi;
        fi;
    done

}

#--------------------------------------------------------------------------------------------------
dump()  # iterates over the unit's collective directory, and examines the presence of the
{       # mutually exclusive flags to prevent collisions (which introduce the ambiguity
        # flag presence interpretation), removes the 'logically inheriting' flags, if the
        # 'ontologically stronger' one ceases to exist (ex. if 'on' changes to 'off', it's
        # obvious that 'acive' or 'inactive' flags become meaningless, if not simply false)

    DIRS=(  ${___CON_ACT___}
            ${___CON_INA___}
            ${___CON_ION___}
            ${___CON_OFF___}
            ${___CON_ENA___}
            ${___CON_DIS___} )

    for UNI in ${REBUNTU}/units/*            # intentionally not using the '= False' comparison,
    do                                       # since (due to some error) the function can also not
        UNIT="${UNI##*/}"                    # return any value at all, what is in this case
        NAME="${UNIT%.*}"                    # lies within the range of the conditional

        if [ "$(activity --enabled ${NAME})" != "True" ]    # not running
        then                                                #     V
            register --disable ${NAME}                      #  disable
            if [ "$(activity --on ${NAME})" = "True" ]      #     V
            then                                            #    off
                register --off ${NAME}                      #   unlock
                register --unlock ${NAME}                   #
            fi                                              #
        else                                                #
            if [ "$(activity --on ${NAME})" = "False" ]     #----- or -----># not 'on'
            then                                                            #    V
                register --off ${NAME}                                      # mark 'off'
                register --unlock ${NAME}                                   # unlock
            else                                                #<--- or ---#
                if [ "$(activity --active ${NAME})" = "False" ] # not active
                then                                            #     V
                    register --inactive ${NAME}                 #  inactive
                fi
            fi
        fi
    done

    for DIR in ${DIRS[@]} # cleaning flags for nonexistent units
    do
        for FILE in $(ls ${DIR})
        do
            if [ ! -e ${REBUNTU}/units/${FILE}.sh ]
            then
                if [ ! -e ${REBUNTU}/units/${FILE}.py ]
                then
                    rm ${DIR}/${FILE}
                fi
            fi
        done
    done
}

#--------------------------------------------------------------------------------------------------
exam()  # maintains the runtime integrity of the major functions of the core unit,
{       # to provide seamless handling of the dynamic stream of the execution and
        # acvitation/inactivation patterns of the daemons

    sleep 1 # give daemons some time to start running

    if [ "$(activity --running core)" != "True" ]
    then
        register --down join
        register --down exam
        register --down loop
        register --down dump
        register --down core
    else
        if [ "$(activity --running join)" != "True" ]
        then
            register --down core
            register --down exam
            register --down loop
            register --down dump
        elif [ "$(activity --running exam)" != "True" ]
        then
            register --down join
            register --down core
            register --down loop
            register --down dump
        elif [ "$(activity --running loop)" != "True" ]
        then
            register --down join
            register --down core
            register --down core
            register --down dump
        elif [ "$(activity --running dump)" != "True" ]
        then
            register --down join
            register --down core
            register --down loop
            register --down core
        fi
    fi
}

#--------------------------------------------------------------------------------------------------
join()  # core's deamon's activity summarization function, oriented on management of the special
{       # flag called 'core', appearing in the 'run' and 'runs' directories of the controller,
        # which acts as an additional confirmation that the core is running in an coherent way

    if [ "$(activity --running join)" = "True" ]
    then
        if [ "$(activity --running exam)" = "True" ]
        then
            if [ "$(activity --running loop)" = "True" ]
            then
                if [ "$(activity --running dump)" = "True" ]
                then
                    register --runs core
                else
                    register --down core
                fi
            else
                register --down core
            fi
        else
            register --down core
        fi
    else
        register --down core
    fi
}

#--------------------------------------------------------------------------------------------------
init()  # execution triggered by the shell-originated call addressed to the core,
{       # makes an attempt to launch the core's primary functions in the daemon mode,
        # since they operate in parallel and interact with one another

    if [ "$(activity --running join)" != "True" ]
    then
        # run join &
        runner join &
    fi

    if [ "$(activity --running exam)" != "True" ]
    then
        # run exam &
        runner exam &
    fi

    if [ "$(activity --running loop)" != "True" ]
    then
        # run loop &
        runner loop &
    fi

    if [ "$(activity --running dump)" != "True" ]
    then
        # run dump &
        runner dump &
    fi

    sleep 0.1 # allow the daemons to 'catch up' before the activity assessment

    if [ "$(activity --running join)" = "True" ]
    then
        if [ "$(activity --running exam)" = "True" ]
        then
            if [ "$(activity --running loop)" = "True" ]
            then
                if [ "$(activity --running dump)" = "True" ]
                then
                    return 0
                else
                    return 1
                fi
            else
                return 1
            fi
        else
            return 1
        fi
    else
        return 1
    fi
}

#--------------------------------------------------------------------------------------------------
if [ "$(controls --imported)" = "True" ]                        #
then                                                            #
    if [ "$(definitions --sourced)" = "True" ]                  #
    then                                                        #   the core will not start
        if [ "$(events --imported)" = "True" ]                  #   until all loads are made
        then                                                    #
            if [ "$(language --sourced)" = "True" ]             #
            then                                                #
                if [ "$(activity --running core)" != "True" ]
                then
                    init

                    if [ "$(activity --running core)" = "True" ]
                    then
                        exit 0  # final return status,
                    else        # expected by the loader
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

#-------------------------------------------------------------------------------------------------#
####        |                                           |                          |              #
#   ########|                                           |                          |              #
#           ############################################|                          |              #
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
