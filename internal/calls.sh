#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/CALLS.SH
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
# LIST:
#
# DONE: ✓

#---------------------------------------

calls()
{
# Syntax:
#		 calls --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

getter()
{
# Syntax:
#
	    if [ -n "${1}" ]
	    then
	        local VARIABLE="${1}"
	    fi

	    if [ -e "${2}" ]
	    then
	        local FILE="${2}"
	    fi

	    if [ -n "${VARIABLE}" ]
	    then
	        if [ -n "${FILE}" ]
	        then
	            if grep -qo "${VARIABLE}: " ${FILE}
	            then
	                local TEMP=$(grep "${VARIABLE}: " ${FILE})
	                echo ${TEMP#*[[:space:]]}
	            elif grep -qo "${VARIABLE}=" ${FILE}
	            then
	                local TEMP=$(grep "${VARIABLE}=" ${FILE})
	                echo ${TEMP#*=}
	            fi
	        fi
	    fi
}

setter()
{
# Syntax:
#
	    if [ -n "${1}" ]
	    then
	        local VARIABLE="${1}"
	    fi

	    if [ -n "${2}" ]
	    then
	        local VALUE="${2}"
	    fi

	    if [ -e "${3}" ]
	    then
	        local FILE="${3}"
	    fi

	    if [ -n "${VARIABLE}" ]
	    then
	        if [ -n "${VALUE}" ]
	        then
	            if [ -n "${FILE}" ]
	            then
	                if grep -qo "${VARIABLE}: " ${FILE}
	                then
	                    sed -i "s/${VARIABLE}:*.*$/${VARIABLE}: ${VALUE}/g" ${FILE}
	                elif grep -qo "${VARIABLE}=" ${FILE}
	                then
	                    sed -i "s:${VARIABLE}=*.*$:${VARIABLE}=${VALUE}:g" ${FILE}
	                fi
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
