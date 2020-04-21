#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/OBJECTS.SH
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
# LIST:		prompt, box, message, request
#
# DONE: ✓

#---------------------------------------

objects()
{
# Syntax:
#		 objects --imported
#

			if [ "${1}" = "--imported" ]
			then
				echo True
			fi
}

#---------------------------------------

prompt()
{
# Syntax:
#		 prompt
#
        if [ "${1}" = "--yn" ]
        then
            local QUESTION="${2}";
            local ACTION="${3}";

            shift 3;

            local ARGUMENTS="${@}";

            let "counter = 0"
            while true
            do
                let "counter = $counter + 1"

                if [ "${counter}" = "1" ]
                then
                    echo -e "\e[94m${QUESTION} \e[0m [y/n]"
                fi

                let "counter_modulo = $counter % 10"

                if [ "${counter_modulo}" = "0" ]
                then
                    clear; echo;
                    echo -e "\e[94m${QUESTION} \e[0m [y/n]"
                fi

                echo;
                read -p "Choice: " choice;

                if [ "${choice}" = "y" ]
                then
                    if [ -n ${ACTION} ]
                    then
                        if [ -z ${ARGUMENTS} ]
                        then
                            eval "${ACTION}"
                        else
                            eval "${ACTION} ${ARGUMENTS}"
                        fi;
                    fi;

                    break;

                elif [ "${choice}" = "Y" ]
                then
                    if [ -n ${ACTION} ]
                    then
                        eval ${ACTION} ${ARGUMENTS}
                    fi;

                    break;

                elif [ "${choice}" = "n" ]
                then
                    break;
                elif [ "${choice}" = "N" ]
                then
                    break;
                else
                    echo;
                    echo -e "\e[91mWrong option chosen. Please input: \e[0m"
                    echo -e "\e[2m[y/Y] \e[0mfor \e[92mYES\e[0m "
                    echo -e "\e[2m[n/N] \e[0mfor \e[31mNO\e[0m "
                fi
            done
        elif [ "${1}" = "--enter" ]
        then
            echo -en "\e[5mPress enter to continue.\e[0m"; read -r -s; echo;
        fi
}

box()
{
# Syntax:
#		 box
#
	    if [ "${1}" = "--yesno" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text="${2}";

					dialog --yesno "${text}" "${height}" "${width}";
			fi; fi;

	    elif [ "${1}" = "--input" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text="${2}";
					local init=${3};

					dialog 	--inputbox "${text} "${height} "${width} "${init};
			fi; fi;


	    elif [ "${1}" = "--message" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text=${2};

					dialog --msgbox ${text} ${height} ${width};
			fi; fi;

	    elif [ "${1}" = "--password" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text=${2};
					local init=${3};

					dialog --passwordbox ${text} ${height} ${width} ${init}; fi; fi;

	    elif [ "${1}" = "--pause" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text=${2};
					local sec=${3};

					dialog --pause ${text} ${height} ${width} ${sec}; fi; fi;

	    elif [ "${1}" = "--q" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local sec=${3};

					dialog --infobox "Quitting ${2}" ${height} ${width}; sleep ${sec}; clear; fi; fi;

	    elif [ "${1}" = "--range" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text=${2};
					local min=${3};
					local max=${4};
					local def=${5};

					dialog --rangebox ${text} ${height} ${width} ${min} ${max} ${def}; fi; fi;

	    elif [ "${1}" = "--text" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local file=${2};

					dialog --textbox ${file} 50 100; fi; fi;

	    elif [ "${1}" = "--calendar" ];
		then
			shift 1; __dim__ "${@}";

			if [ -n ${width} ]
			then
				if [ -n ${height} ]
				then
					local text=${2};
					local day=${3};
					local mnth=${4};
					local yr=${5};

					dialog --calendar ${text} ${height} ${width} ${day} ${mnth} ${yr}; fi; fi;
	    fi;
}

channel()
{
# Syntax:
#        channel --test
#        channel --input
#        channel --output
#        channel --check
#

        w_()
        {
            for line in $@
            do
                echo "${line}"
            done

        }

        __input()
        {
                    __FROM__="${___INC_FRO___}/${__NAME__}"
                    __WHAT__="${___INC_WHA___}/${__NAME__}"
                    __WITH__="${___INC_WIT___}/${__NAME__}"
                    __WHEN__="${___INC_WHE___}/${__NAME__}"
                    __WHOM__="${___INC_WHO___}/${__NAME__}"
                    __DATA__="${___INC_DAT___}/${__NAME__}"
        }

        output__()
        {
                    __FROM__="${___OUT_FRO___}/${__NAME__}"
                    __WHAT__="${___OUT_WHA___}/${__NAME__}"
                    __WITH__="${___OUT_WIT___}/${__NAME__}"
                    __WHEN__="${___OUT_WHE___}/${__NAME__}"
                    __WHOM__="${___OUT_WHO___}/${__NAME__}"
                    __DATA__="${___OUT_DAT___}/${__NAME__}"
        }

        __pipe__()
        {
                    __FROM__="${___INC_FRO___}/${1}";
                    __WHAT__="${___INC_WHA___}/${1}";
                    __WITH__="${___INC_WIT___}/${1}";
                    __WHEN__="${___INC_WHE___}/${1}";
                    __WHOM__="${___INC_WHO___}/${1}";
                    __DATA__="${___INC_DAT___}/${1}";
        }

        __complete()
        {
                    __input;
                    if [ ! -e ${__FROM__} ]; then COMPLETE=False; fi;
                    if [ ! -e ${__WHAT__} ]; then COMPLETE=False; fi;
                    if [ ! -e ${__WITH__} ]; then COMPLETE=False; fi;
                    if [ ! -e ${__WHEN__} ]; then COMPLETE=False; fi;
                    if [ ! -e ${__WHOM__} ]; then COMPLETE=False; fi;
                    if [ ! -e ${__DATA__} ]; then COMPLETE=False; fi;

                    [ "${COMPLETE}" = "False" ] && echo False || echo True;
        }

        complete__()
        {
                    if [ ! -e "${__FROM__}" ]; then COMPLETE=False; fi;
                    if [ ! -e "${__WHAT__}" ]; then COMPLETE=False; fi;
                    if [ ! -e "${__WITH__}" ]; then COMPLETE=False; fi;
                    if [ ! -e "${__WHEN__}" ]; then COMPLETE=False; fi;
                    if [ ! -e "${__WHOM__}" ]; then COMPLETE=False; fi;
                    if [ ! -e "${__DATA__}" ]; then COMPLETE=False; fi;

                    [ "${COMPLETE}" = "False" ] && echo False || echo True;
        }

        __read()
        {
                    __FROM=$(cat ${__FROM__}) && rm ${__FROM__};
                    __WHAT=$(cat ${__WHAT__}) && rm ${__WHAT__};
                    __WITH=$(cat ${__WITH__}) && rm ${__WITH__};
                    __WHEN=$(cat ${__WHEN__}) && rm ${__WHEN__};
                    __WHOM=$(cat ${__WHOM__}) && rm ${__WHOM__};
                    __DATA=$(cat ${__DATA__}) && rm ${__DATA__};
        }

        write__()
        {
                    [ -n "${FROM__}" ] && w_ "${FROM__}" > ${__FROM__} || w_ 0 > ${__FROM__};
                    [ -n "${WHAT__}" ] && w_ "${WHAT__}" > ${__WHAT__} || w_ 0 > ${__WHAT__};
                    [ -n "${WITH__}" ] && w_ "${WITH__}" > ${__WITH__} || w_ 0 > ${__WITH__};
                    [ -n "${WHEN__}" ] && w_ "${WHEN__}" > ${__WHEN__} || w_ 0 > ${__WHEN__};
                    [ -n "${WHOM__}" ] && w_ "${WHOM__}" > ${__WHOM__} || w_ 0 > ${__WHOM__};
                    [ -n "${DATA__}" ] && w_ "${DATA__}" > ${__DATA__} || w_ 0 > ${__DATA__};

        }

        out__()
        {
                    if [ -n ${__NAME__} ]
                    then
                        FROM__="${__NAME__}";

                        if [ -n "${REQUEST}" ];
                        then WHAT__="${REQUEST}";
                        else WHAT__=0; fi;

                        if [ -n "${ARGUMENTS}" ];
                        then WITH__="${ARGUMENTS}";
                        else WITH__=0; fi;

                        if [ -n "${TIME}" ];
                        then WHEN__="${TIME}";
                        else WHEN__=0; fi

                        if [ -n "${RESULTS}" ];
                        then DATA__="${RESULTS}";
                        else DATA__=0; fi;

                    fi


                    if [ -n "${1}" ]
                    then
                        for WHOM in ${@}
                        do
                            __pipe__ "${WHOM}"; WHOM__="${WHOM}";
                            write__
                            [ "${DEBUG}" = "True" ] \
                            && echo -e "\e[36mName: \e[32m\e[5m ${__NAME__} \e[0m\e[0m";
                            [ "${DEBUG}" = "True" ] \
                            && echo -e "\e[36mRequest: \e[32m\e[5m ${WHAT__} \e[0m\e[0m";
                            [ "${DEBUG}" = "True" ] \
                            && echo -e "\e[36mArguments: \e[32m\e[5m ${WITH__} \e[0m\e[0m";
                            [ "${DEBUG}" = "True" ] \
                            && echo -e "\e[36mTime: \e[32m\e[5m ${WHEN__} \e[0m\e[0m";
                            [ "${DEBUG}" = "True" ] \
                            && echo -e "\e[36mWhom: \e[32m\e[5m ${WHOM__} \e[0m\e[0m";
                        done
                    else
                        output__
                        write__
                        [ "${DEBUG}" = "True" ] \
                        && echo -e "\e[36mName: \e[32m\e[5m ${__NAME__} \e[0m\e[0m";
                        [ "${DEBUG}" = "True" ] \
                        && echo -e "\e[36mRequest: \e[32m\e[5m ${WHAT__} \e[0m\e[0m";
                        [ "${DEBUG}" = "True" ] \
                        && echo -e "\e[36mArguments: \e[32m\e[5m ${WITH__} \e[0m\e[0m";
                        [ "${DEBUG}" = "True" ] \
                        && echo -e "\e[36mTime: \e[32m\e[5m ${WHEN__} \e[0m\e[0m";
                        [ "${DEBUG}" = "True" ] \
                        && echo -e "\e[36mWhom: \e[32m\e[5m ${WHOM__} \e[0m\e[0m";
                    fi
        }

        __in()
        {
                    if [ "$(__complete)" = "True" ]
                    then
                        __read
                        if [ "${DEBUG}" = "True" ]
                        then
                            echo -e "\e[36mFrom: \e[31m\e[5m ${__FROM} \e[0m\e[0m "
                            echo -e "\e[36mWhat: \e[31m\e[5m ${__WHAT} \e[0m\e[0m "
                            echo -e "\e[36mWith: \e[31m\e[5m ${__WITH} \e[0m\e[0m "
                            echo -e "\e[36mWhen: \e[31m\e[5m ${__WHEN} \e[0m\e[0m "
                            echo -e "\e[36mWhom: \e[31m\e[5m ${__WHOM} \e[0m\e[0m "
                        fi
                    fi
        }

        if [ "${1}" = "--in" ]
        then
            __in
        elif [ "${1}" = "--out" ]
        then
            if [ -n "${2}" ]
            then
                shift 1
                out__ "${@}"
            else
                out__
            fi
        fi
}

header()
{
# Syntax:
# 		 header --declare
#		 header --check
# 		 header --print
#

		if [[ "${BASH_SOURCE[0]}" != "${0}" ]]
		then
			if [ "${0}" != "/bin/bash" ]
			then
				if [ "${1}" = "--define" ]
				then
					__NAME__="$(t=${0%.*}; echo ${t##*/};)"; unit=${__NAME__};
					__FILE__="${0}";
					__HOME__="${0%/*}";
					__NEAR__="$(t=${0%/*}; echo ${t%/*};)"
				elif [ "${1}" = "--print" ]
				then
					echo "__NAME__=${__NAME__}"
					echo "__FILE__=${__FILE__}"
					echo "__HOME__=${__HOME__}"
					echo "__NEAR__=${__NEAR__}"
				fi
			fi
		fi
}

separator()
{
# Syntax:
#		 separator
#
			if [ "${1}" = "--red" ]
			then
				for i in $(seq 1 $(echo $(stty size | awk '{printf $2}')));
	            do
	                echo -e -n "\e[31m─";
	            done;
			else
				for i in $(seq 1 $(echo $(stty size | awk '{printf $2}')));
	            do
	                echo -e -n "\e[0m─";
	            done;
			fi;
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
