#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/CONTROLS.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:      Engine internal control functions.
#
# REALM:     engine
#
# DOMAIN:    execution
#
# ROLE:      reliability assessment of the execution flow
#            activity monitoring of the components
#            runtime characteristics adjustment
#            error reporting
#
# LIST:      getter, setter, activity, register, frequency
#
# IMPORTANT: each function should contain definitions import conditional clause,
#            to ensure that the complete set of global variable declarations is
#            available 'at hand', otherwise the reference used in the expression
#            might not point to the address correctly
#
#            ( caluse-containing function, declared as '___', shall be called
#              right after the comments under the parent function declaration )
#
# DONE: ✓

#---------------------------------------

controls()
{
#
# Description:
#
# Syntax:
#		 controls --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

activity()	# Returns the truth value of the correct query for an existing
{			# component in regards to the component's runtime activity.
# Syntax:
#        activity --locked <UNIT>
#        activity --activated <UNIT>
#        activity --inactivated <UNIT>
#        activity --enabled <UNIT>
#        activity --disabled <UNIT>
#        activity --on <UNIT>
#        activity --off <UNIT>
#        activity --running <COMPONENT>
#

        if [ -n ${2} ]
        then
            if [ "${1}" = "--locked" ]; then

                [ -e ${___CON_LOK___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--activated" ]; then

                [ -e ${___CON_ACT___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--inactivated" ]; then

                [ -e ${___CON_INA___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--enabled" ]; then

                [ -e ${___CON_ENA___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--disabled" ]; then

                [ -e ${___CON_DIS___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--on" ]; then

                [ -e ${___CON_ION___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--off" ]; then

                [ -e ${___CON_OFF___}/${2} ] && echo True || echo False

            elif [ "${1}" = "--running" ]; then

                [ -e ${___CON_RUN___}/${2} ] && echo True || echo False

            fi
        else

            if [ -n ${1} ]
            then

                [ -e ${___CON_VAR___}/${1} ] && echo True || echo False

            fi
        fi
}

register()	# Registers state change for given component using file flags method.
{
# Syntax:
#        register --lock <UNIT>
#        register --unlock <UNIT>
#        register --active <UNIT>
#        register --inactive <UNIT>
#        register --on <UNIT>
#        register --off <UNIT>
#        register --enable <UNIT>
#        register --disable <UNIT>
#        register --run <COMPONENT>
#        register --halt <COMPONENT>
#

        if [ -n "${2}" ]
        then
            # control
            if [ "${1}" = "--lock" ]; then

                [ -e ${___CON_LOK___}/${2} ] || touch ${___CON_LOK___}/${2}

            elif [ "${1}" = "--unlock" ]; then

                [ -e ${___CON_LOK___}/${2} ] && rm -f ${___CON_LOK___}/${2}

            elif [ "${1}" = "--active" ]; then

                if [ -e ${___CON_ION___}/${2} ]; then

                    [ -e ${___CON_INA___}/${2} ] && rm -f ${___CON_INA___}/${2}
                    [ -e ${___CON_ACT___}/${2} ] || touch ${___CON_ACT___}/${2}
                fi

            elif [ "${1}" = "--inactive" ]; then

                if [ -e ${___CON_ION___}/${2} ]; then

                    [ -e ${___CON_ACT___}/${2} ] && rm -f ${___CON_ACT___}/${2}
                    [ -e ${___CON_INA___}/${2} ] || touch ${___CON_INA___}/${2}
                fi

            elif [ "${1}" = "--on" ]; then

                [ -e ${___CON_OFF___}/${2} ] && rm -f ${___CON_OFF___}/${2}
                [ -e ${___CON_ION___}/${2} ] || touch ${___CON_ION___}/${2}

            elif [ "${1}" = "--off" ]; then

                [ -e ${___CON_ION___}/${2} ] && rm -f ${___CON_ION___}/${2}
                [ -e ${___CON_ACT___}/${2} ] && rm -f ${___CON_ACT___}/${2}
                [ -e ${___CON_INA___}/${2} ] && rm -f ${___CON_INA___}/${2}
                [ -e ${___CON_OFF___}/${2} ] || touch ${___CON_OFF___}/${2}

            elif [ "${1}" = "--enable" ]; then

                [ -e ${___CON_DIS___}/${2} ] && rm -f ${___CON_DIS___}/${2}
                [ -e ${___CON_ENA___}/${2} ] || touch ${___CON_ENA___}/${2}

            elif [ "${1}" = "--disable" ]; then

                [ -e ${___CON_ENA___}/${2} ] && rm -f ${___CON_ENA___}/${2}
                [ -e ${___CON_DIS___}/${2} ] || touch ${___CON_DIS___}/${2}

            elif [ "${1}" = "--runs" ]; then

                [ -e ${___CON_RUN___}/${2} ] || touch ${___CON_RUN___}/${2}
                [ -e ${___CON_RNS___}/${2} ] || touch ${___CON_RNS___}/${2}

            elif [ "${1}" = "--down" ]; then

                [ -e ${___CON_RUN___}/${2} ] && rm -f ${___CON_RUN___}/${2}
                [ -e ${___CON_RNS___}/${2} ] && rm -f ${___CON_RNS___}/${2}

            elif [ "${1}" = "--variable" ]; then

                [ -e ${___CON_VAR___}/${2} ] || touch ${___CON_VAR___}/${2}

            elif [ "${1}" = "--delete" ]; then

                [ -e ${___CON_VAR___}/${2} ] && rm -f ${___CON_VAR___}/${2}
            fi
        fi
}

frequency()
{
# Syntax:
#        delay <UNIT>
#
# Options:
#         every -
#               hour
#               minute
#               second
#
#               N hours
#               N minutes
#               N seconds
#         each
#
		local DEFAULT=1

		sleep ${DEFAULT}

        # if [ -e ${___REG_FRE___} ]
        # then
        #     while read line
        #     do
		# 		if [ -n "${1}" ]
		# 		then
	    #             if [ "${line%%:*}" = "${1}" ]
	    #             then
	    #                 SETTING="${line##*:}"
		#
	    #                 if [ "${#SETTING}" = "0" ]
	    #                 then
	    #                     sleep ${DEFAULT}
		#
	    #                 elif [ "${1}" = "--panel" ]
	    #                 then
	    #                     sleep 1
		#
	    #                 else
	    #                     if [ "$(echo ${SETTING} | awk '{print $1}')" = "every" ]
	    #                     then echo 'every'
	    #                         if [ "$(echo ${SETTING} | awk '{print $2}')" = "hour" ]
	    #                         then
	    #                             sleep 3600
	    #                         elif [ "$(echo ${SETTING} | awk '{print $2}')" = "minute" ]
	    #                         then
	    #                             sleep 60
	    #                         elif [ "$(echo ${SETTING} | awk '{print $2}')" = "second" ]
	    #                         then
	    #                             sleep 1
	    #                         fi
	    #                     elif [ "$(echo ${SETTING} | awk '{print $1}')" = "each" ]
	    #                     then echo 'each'
	    #                         if [ "$(echo ${SETTING} | awk '{print $2}')" = "hour" ]
	    #                         then
	    #                             while [ "$(date +%M)" != "00" ]; do sleep 1; done;
	    #                         elif [ "$(echo ${SETTING} | awk '{print $2}')" = "minute" ]
	    #                         then
	    #                             while [ "$(date +%S)" != "00" ]; do sleep 1; done;
	    #                         elif echo ${SETTING} | awk '{print $2}' | grep -qo "[[:digit:]]"
	    #                         then
	    #                             NTH="$(echo ${SETTING} | awk '{print $2}')"
		#
	    #                             if [ "$(echo ${SETTING} | awk '{print $3}')" = "hour" ]
	    #                             then
	    #                                 while [ "$(date +%H)" != "${NTH}" ]; do sleep 1; done;
		#
	    #                             elif [ "$(echo ${SETTING} | awk '{print $3}')" = "minute" ]
	    #                             then
	    #                                 while [ "$(date +%M)" != "${NTH}" ]; do sleep 1; done;
		#
	    #                             elif [ "$(echo ${SETTING} | awk '{print $3}')" = "second" ]
	    #                             then
	    #                                 while [ "$(date +%S)" != "${NTH}" ]; do sleep 1; done;
	    #                             fi
	    #                         fi
        #                     elif echo ${SETTING} | awk '{print $1}' | grep -q "[[:digit:]]"
        #                     then
        #                         NUMBER="$(echo ${SETTING} | awk '{print $1}')"
		#
        #                         if [ "$(echo ${SETTING} | awk '{print $2}')" = "hours" ]
        #                         then
        #                             let "N = ${NUMBER} * 3600";
        #                             sleep ${N};
        #                         elif [ "$(echo ${SETTING} | awk '{print $2}')" = "minutes" ]
        #                         then
        #                             let "N = ${NUMBER} * 60";
        #                             sleep ${N};
        #                         elif [ "$(echo ${SETTING} | awk '{print $2}')" = "seconds" ]
        #                         then
        #                             let "N = ${NUMBER} * 1";
        #                             sleep ${N};
        #                         fi
	    #                     else
	    #                         sleep ${DEFAULT}
	    #                     fi
	    #                 fi
	    #             else
	    #                 sleep ${DEFAULT}
	    #             fi
		# 		else
        #     		sleep ${DEFAULT}
		# 		fi
        #     done < ${___REG_FRE___}
        # else
        #     sleep ${DEFAULT}
        # fi
}

settings()
{
# Syntax:
#		 settings <SETTING>

		. ${REBUNTU}/internal/calls.sh

		if [ -n ${1} ]
		then
			if [ "$(getter ${1} ${___USR_SET___})" = "" ]
			then
				echo False
			else
				echo "$(getter ${1} ${___USR_SET___})"
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
