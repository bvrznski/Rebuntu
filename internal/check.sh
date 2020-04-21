#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/CHECK.SH
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

check()
{
# Syntax:
#		 check --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		elif [ "${1}" = "--root" ]
		then
            if (( $EUID != 0 ))
            then
                echo True
            else
                echo False
            fi
		elif [ "${1}" = "--sourced" ]
		then
            if [[ "${BASH_SOURCE[0]}" != "${0}" ]]
            then
                echo True
            else
                echo False
            fi
		fi
}

#---------------------------------------

modified()
{
# Syntax:
#
		if [ "${1}" = "--within" ]
		then
			local MODIFIED="$(echo $(( $(date +%s) - $(stat ${4}  -c %Y) )))"

			if [ "${3}" = "seconds" ]
			then
				if [ "${2}" -gt "${MODIFIED}" ]
				then
					echo True
				else
					echo False
				fi

			elif [ "${3}" = "minutes" ]
			then
				let "MOD = $MODIFIED / 60"; local M="${MOD%.*}";

				if [ "${2}" -gt "${M}" ]
				then
					echo True
				else
					echo False
				fi
			elif [ "${3}" = "hours" ]
			then
				let "MOD = $MODIFIED / 3600"; local M="${MOD%.*}";

				if [ "${2}" -gt "${M}" ]
				then
					echo True
				else
					echo False
				fi
			fi
		elif [ "${1}" = "--when" ]
		then
			local MODIFIED="$(echo $(( $(date +%s) - $(stat ${2}  -c %Y) )))"

			if [ "${MODIFIED}" -lt "60" ]
			then
				echo "${MODIFIED} seconds ago"
			elif [ "${MODIFIED}" -gt "60" ]
			then
				let "MOD = $MODIFIED / 60"; local M="${MOD%.*}";

				if [ "${M}" = "1" ]
				then
					echo "1 minute ago"
				else
					echo "${M} minutes ago"
				fi

			elif [ "${MODIFIED}" -gt "3600" ]
			then

				let "MOD = $MODIFIED / 3600"; local M="${MOD%.*}";

				if [ "${M}" = "1" ]
				then
					echo "1 hour ago"
				else
					echo "${M} hours ago"
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
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
