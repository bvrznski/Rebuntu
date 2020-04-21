#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/MODES.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:
#
# REALM:
#
# DOMAIN:
#
# ROLE:
#
# LIST:     debug
#
# DONE: ✓

#---------------------------------------

modes()
{
# Syntax:
#		 modes --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

debug()
{
# Syntax:
#        debug --
#        debug --
#
        if [ -n "${DEBUG}" ]
        then
            if [ "${DEBUG}" = "True" ]
            then
                if [ "${1}" = "--header" ]
                then
                    echo -e "\e[36m---------- REBUNTU LOADING ---------- \e[0m "
                elif [ "${1}" = "--status" ]
                then
                    if [ -n "${RESULT}" ]
                    then
                        if [ "${RESULT}" = "True" ]
                        then
                            echo -e "\e[37mStatus: \e[32mSuccess \e[0m "
                        elif [ "${RESULT}" = "False" ]
                        then
                            echo -e "\e[37mStatus: \e[31m\e[5mFailure \e[0m "
                        fi
                    else
                        echo -e "\e[37mStatus: \e[31m\e[5mNone \e[0m "
                    fi

                elif [ "${1}" = "--stage" ]
                then
                    if [ -n "${2}" ]
                    then
                        __STAGE__="${2}"
                        echo -e "\e[37mStage: \e[36m${__STAGE__} \e[0m "
                    fi
                else
                    DEBUG=False
                fi
            fi
        fi
}

#--------------------------------------------------------------------------------------------------

if REBUNTU="$(l1=$(grep "REBUNTU_LOCATION=" /etc/rebuntu.conf);
              l2=${l1##*=}; echo "${l2}")";
then
    [ -e ${REBUNTU}/sources/definitions.sh ] \
    && . ${REBUNTU}/sources/definitions.sh;
fi

#--------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------#
############|                                                                      |              #
########|   |                                                                  	   |              #
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
