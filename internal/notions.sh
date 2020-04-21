#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/NOTIONS.SH
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

notions()
{
# Syntax:
#		 notions --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

stamp()
{
# Syntax:
#
		if [ "${1}" = "--check" ]
		then
			if ! echo "${2}" | grep -q "notions.sh"
			then
				if cat "${2}" | grep -q "DONE:*.*✗"
				then
					sed -i "s/DONE\: ✗/DONE\: ✓/g" ${2}
				fi
			fi
		elif [ "${1}" = "--uncheck" ]
		then
			if ! echo "${2}" | grep -q "notions.sh"
			then
				if cat "${2}" | grep -q "DONE:*.*✓"
				then
					sed -i "s/DONE\: ✓/DONE\: ✗/g" ${2}
				fi
			fi
		elif [ "${1}" = "--mark" ]
		then
			if ! echo "${2}" | grep -q "notions.sh"
			then
				if cat "${2}" | grep -q "DONE:[[:space:]]$"
				then
					sed -i "s/DONE\:/DONE\: ✗/g" ${2}
				elif cat "${2}" | grep -q "DONE:$"
				then
					sed -i "s/DONE\:/DONE\: ✗/g" ${2}
				elif cat "${2}" | grep -q "DONE:[[:space:]]*[[:space:]]$"
				then
					sed -i "s/DONE\:/DONE\: ✗/g" ${2}
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
