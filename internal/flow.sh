#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/FLOW.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:		Unit's internal execution flow control functions.
#
# REALM:	units
#
# DOMAIN:	control flow
#
# ROLE:		execution flow regulation
#			processing type selection
#
# LIST:		gate, registry, execution
#
# DONE: ✓

#---------------------------------------

flow()
{
# Syntax:
#		 flow --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

gate()
{
# Syntax:
#		 gate
#
	    local DIR="${1}"
	    local CMD="${2}"

	    if [ -d "${DIR}" ]
	    then
	        cd ${DIR}

	        if [ "$(pwd)" = "${DIR}" ]
	        then
	            eval "${CMD}"
	        fi

	        cd - > /dev/null 2>&1
	    fi
}


registry()	# Returns the truth value of the correct parameter query for
{
# Syntax:
#		 registry
#
		local LEDGER="${___RUN_LED___}/${2}"

		if [ "${1}" = "--locked" ]
		then
			if [ -n ${3} ]
			then
				if [ -n ${4} ]
				then
					while read line
					do
						local VAR="${line%%:*}"

						if [ "${VAR}" = "${3}-${4}" ]
						then
							local VAL="${line##*[[:space:]]}"

							if [ "${VAL}" = "enabled" ]
							then
								echo False
							else
								echo True
							fi
						fi
					done < ${LEDGER}
				else
					while read line
					do
						local VAR="${line%%:*}"

						if [ "${VAR}" = "${3}" ]
						then
							local VAL="${line##*[[:space:]]}"

							if [ "${VAL}" = "enabled" ]
							then
								echo False
							else
								echo True
							fi
						fi
					done < ${LEDGER}
				fi
			fi
		elif [ "${1}" = "--flow" ]
		then
			while read line
			do
				local VAR="${line%%:*}"

				if [ "${VAR}" = "${unit}" ]
				then
					local VAL="${line##*[[:space:]]}"
					echo $VAL
				fi
			done < ${___REG_EXE___}
		fi

}

execution()
{
# Syntax:
#        execution --run
#        execution --tasks
#
		__parallel__()
		{
			for STAGE in $@
			do
				if cat ${LEDGER} | grep -qo "${STAGE}:"
 				then
					true
				else
					echo "${STAGE}: enabled" >> ${LEDGER}
				fi

				if [ "$(registry --locked ${unit} ${STAGE})" != "True" ]
				then
					eval $STAGE &
				fi
			done
		}

		__sequential__()
		{
			for STAGE in $@
			do
				if cat ${LEDGER} | grep -qo "${STAGE}:"
 				then
					true
				else
					echo "${STAGE}: enabled" >> ${LEDGER}
				fi

				if [ "$(registry --locked ${unit} ${STAGE})" != "True" ]
				then
					eval $STAGE
				fi
			done
		}

		___tasks___()
		{
			for TASK in $@
			do
				if cat ${LEDGER} | grep -qo "${stage}-${TASK}:"
 				then
					true
				else
					echo "${stage}-${TASK}: enabled" >> ${LEDGER}
				fi

				if [ "$(registry --locked ${unit} ${stage} ${TASK})" != "True" ]
				then
					eval $TASK
				fi
			done
		}

		___traverser___()
		{
		    local TYPE="${1}"
		    local DIRS=()
		    local CMDS=()

		    let "pos = 0"
		    for arg in $@
		    do
		        let "pos = $pos + 1"
		        if echo "${arg}" | grep -q "<dir>"
		        then
		            let "position = ${pos}";
		        fi;
		    done;

		    let "num = 0"
		    for arg in $@
		    do
		        let "num = $num + 1"
		        if [ "${num}" -gt "${position}" ]
		        then
		            DIRS+=( "${arg}" )
		        fi;
		    done;

		    let "count = 0"
		    for arg in $@
		    do
		        let "count = $count + 1"
		        if [ "${count}" -gt "2" ]
		        then
		            if [ "${count}" -lt "${position}" ]
		            then
		                CMDS+=( "${arg}" )
		            fi;
		        fi;
		    done;

		    for DIR in ${DIRS[@]}
		    do
		        if [ -d ${DIR} ]
		        then
		            cd ${DIR}

		            if [ "$(pwd)" = "${DIR}" ]
		            then
		                for CMD in ${CMDS[@]}
		                do
		                    execution "${TYPE}" "${CMD}"
		                done
		            fi
		            cd - > /dev/null 2>&1
		        fi
		    done

		    unset DIRS
		    unset CMDS
		}

		local LEDGER="${___RUN_LED___}/${unit}"

		[ -d ${___RUN_LED___} ] || mkdir -p ${___RUN_LED___}
		[ -e ${LEDGER} ] || touch ${LEDGER}

		if [ "${1}" = "--run" ]
		then
			if [ "${2}" = "---traverser" ]
			then
				___traverser___ "$@";
			else
				if [ "$(registry --flow ${unit})" = "P" ]
				then
					shift 1; __parallel__ $@;
				else
					shift 1; __sequential__ $@;
				fi
			fi
		elif [ "${1}" = "--tasks" ]
		then
			if [ "${2}" = "---traverser" ]
			then
				___traverser___ "$@";
			else
				shift 1; ___tasks___ $@;
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
