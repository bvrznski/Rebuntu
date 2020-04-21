#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /SYSTEM/IMPORT.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:		Primary source loading function.
#
# ROLE:		internal functions sourcing encapsulation
#
# REALM:	global
#
# DOMAIN:	sourcing
#
# LIST:		import
#
# DONE: ✓

import()
{
	if [ "${1}" = "--sourced" ]									# function sourcing check
	then
		echo True
	else
		if REBUNTU="$(l1=$(grep "REBUNTU_LOCATION=" /etc/rebuntu.conf);
		              l2=${l1##*=}; echo "${l2}")";
		then
			[ -e ${REBUNTU}/sources/definitions.sh ] \
	        && . ${REBUNTU}/sources/definitions.sh;

			local num=${#@}										# number of 'imports'

			let "done = 0"

			for arg in $@
			do
				local FILE="${REBUNTU}/internal/${arg:2}.sh"
				[ -e ${FILE} ] && . ${FILE}						# 'import' (source) indicated
				[ "$?" = "0" ] && let "done = $done + 1"		# resource from /internal folder
			done

			[ "${done}" = "${num}" ] && return 0 || return 1
		fi
	fi
}
