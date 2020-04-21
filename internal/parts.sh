#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/PARTS.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:
#
# ROLE:
#
# REALM:
#
# DOMAIN:
#
# LIST:		header, delay,
#
# DONE: ✓

#---------------------------------------

parts()
{
# Syntax:
#		 parts --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

runner() # daemonizes engine's component's internal functions
{
# Syntax:
#		 runner <FUNCTION>
#

	# Loop execution pattern:
	#
	# init ---->*<----------------*
	#           |                 ^
	# instance lock check         | -> lock created upon the 'first' initialization call,
	#           |                 |    prevent's the script from being run twice at the same time
	# switch/control flag check   | -> if the switch flag is present, the loop enters the new
	#           |                 |    execution cycle
	# ACTIVITY (processing) phase | -> actual task or functionality-oriented processing phase,
	#           |                 |    marked by the special activity-driven flags creation
	# INACTIVITY (delay) phase    | -> processing stage is followed by the near-complete
	#           V                 |    process inactivity period, deprived of any computational
	#           *---------------->*    tasks in order to avoid the 'speed and repetition density'
	#                                  CPU load, since the frequency is intended to be within the
	#                                  range of human scale of processing speed (very fast tasks),
	#                                  or to be trackable in time, allowing the user to monitor
	#                                  the execution patterns and computation-reulting changes

	# relies on three directories of the controller:
	# - run:  file flags act as switches for each of the daemon
	# - runs: file flags only inform about the daemon's activity
	# - lock: file flags prevent from creating multiple instances
	#         of the same daemon and provide reliability

	local CALLER=$(t="${0}"; t2=${t%.*}; echo ${t2##*/});

    if [ "$(activity --locked ${1})" != "True" ]            # instance locking
    then
        register --lock ${1}

        if [ "$(activity --running ${1})" = "False" ]       # checks if a daemon is inactive and
        then                                                # registers the activation
            register --runs ${1}

            if [ "$(activity --running ${1})" = "True" ]    # checks the flag creation
            then                                            # if successful, the daemon
                while true                                  # enters a loop
                do
                    if [ "$(activity --running ${1})" = "True" ]
                    then
                        register --runs ${1}                        # reinforces flag's presence

                        eval "${@}"                                 # core function call
                        frequency "${1}"                            # modulates frequency upon
                    else                                            # the parameter stored in
                        register --down ${1}                        # the frequency register

                        if [ "$(activity --running ${1})" = "False" ]
                        then
                            register --unlock ${1}
                            break
                        else
                            error run-jammed-exit ${CALLER} ${1} 	# JAMMED EXIT ERROR:
							break									# the activity flag
                                                       				# either can't be removed,
                        fi                                  		# or the execution got stuck
                    fi                                      		# inside the called function
                done
            else
                error run-runtime-register-fail ${CALLER} ${1}   	# RUNTIME REGISTRATION ERROR
                register --down ${1}                        		# unsuccessfull activity flag
            fi                                              		# creation,
        fi                                                  		# daemon not launched,
    fi                                                      		# lock preserved to 'contain'
}																	# the faulty execution cycle

parser()
{
# Syntax:
#		 parser <DIRECTORY> <SEARCH PHRASE> <MATCH PHRASE>
#
		if [ "${1}" = "--settings" ]
		then
			parser ${REBUNTU} '(setting [A-Z]' '[^ "][A-Z]*[A-Z]'
		else
		    cd ${1};

		    if [ "$(pwd)" = "${1}" ]
		    then
		        local TEMP=/tmp/$RANDOM

		        for f in $(find . -type f -name "*.sh")
		        do
		            cat ${f} | grep "${2}" >> ${TEMP}
		            #cat ${1} | grep '(setting [A-Z]' >> ${TEMP}

		            while read line
		            do
		                echo ${line} | grep -o "${3}"
		            done < ${TEMP}
		        done

		        rm ${TEMP}
		    fi

	    	cd - > /dev/null 2>&1;
		fi
}

enlister()
{
# Syntax:
#		 enlister
#
		if [ -n ${1} ]
		then
			REGISTER="${1}"
		fi

		if [ -n ${REGISTER} ]
		then
			for f in ${REBUNTU}/units/*
		    do
		        F=$(echo ${f} | sed -e 's/\(.*\)/\U\1/')
		        grep -qo "${F}" ${REGISTER} \
		         || echo "${F}=" >> ${REGISTER};
		    done

		    for UNI in ${REBUNTU}/units/*
		    do
		        UNIT="${UNI##*/}"
		        NAME="$(echo ${UNIT%.*} | sed -e 's/\(.*\)/\U\1/';)"

		        if [ ! -e ${REBUNTU}/units/${UNIT}.sh ]
		        then
		            if [ ! -e ${REBUNTU}/units/${UNIT}.py ]
		            then
		                sed -i "/${NAME}/d" ${REGISTER}
		            fi
		        fi
			done
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
