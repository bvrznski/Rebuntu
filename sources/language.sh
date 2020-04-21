#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /SOURCES/LANGUAGE.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:		'Additional bash builtins.'
#
# ROLE:		shell scriptiong enhancement
#
# REALM:	shell
#
# DOMAIN:	featuring
#
# LIST:		langugage, upper, lower, replace, insert, integer, random, average, try, speak, exists,
#           extension, count, odd, even
#
# DONE: ✓

#---------------------------

language()
{
#
# Description:
#
# Syntax:
#
#
        if [ "${1}" = "--sourced" ]
        then
            echo True
        fi
}

#---------------------------

upper()
{
#
# Description:
#
# Syntax:
#
        if [ -n "${1}" ]
        then
            echo "${1}" | sed -e 's/\(.*\)/\U\1/'
        fi
}

lower()
{
#
# Description:
#
# Syntax:
#
        if [ -n "${1}" ]
        then
            echo "${1}" | sed -e 's/\(.*\)/\L\1/'
        fi

}

replace()
{
#
# Description:
#
# Syntax:
#
        if [ "${1}" = "--line" ]
        then
            true
        elif [ "${1}" = "--string" ]
        then
            true
        elif [ "${1}" = "--text" ]
        then
            true
        fi
}

insert()
{
#
# Description:
#
# Syntax:
#
        if [ "${1}" = "--before" ]
        then
            sed -i "${LINE} i ${TEXT}" ${FILE}
        elif [ "${1}" = "--after" ]
        then
            sed -i "${LINE} a ${TEXT}" ${FILE}
        elif [ "${1}" = "--in-place" ]
        then
            true
        fi
}

integer()
{
#
# Description:
#
# Syntax:
#
        local PROPER=$(echo "${1}" | grep -o "^[0-9]*")
        local ACTUAL="${1}"

        if [ "${ACTUAL}" = "${PROPER}" ]
        then
            echo True
        else
            echo False
        fi
}

random()
{
#
# Description:
#
# Syntax:
#
#
        if [ -n "${1}" ]
        then
            if [ -n "${2}" ]
            then
                MIN="${1}"
                MAX="${2}"

                while :;
                do
                    ran=$RANDOM;
                    ((ran < ${MAX})) && ((ran > ${MIN})) && echo ${ran} && break;
                done
            else
                MIN=0
                MAX="${1}"

                while :;
                do
                    ran=$RANDOM;
                    ((ran < ${MAX})) && ((ran > ${MIN})) && echo ${ran} && break;
                done
            fi
        else
            echo $RANDOM
        fi
}

average()
{
#
# Description:
#
# Syntax:
#
#
        ARR=("$@")

        len=${#ARR[@]}

        let "sum = 0"

        for i in ${ARR[@]}
        do
            let "sum = $sum + $i"
        done

        let "approx = $sum / $len"

        if [ "${approx#*.}" -gt "5" ]
        then
            let "result = ${approx%.*} + 1"
        else
            let "result = ${approx%.*}"
        fi

        if [ -n ${result} ]
        then
            echo ${result}
        fi

        unset ARR
}

try()
{
#
# Description:
#
# Syntax:
#
#
        declare CODE
        declare DEFAULT
        declare ARGUMENTS
        declare EXCEPTIONS
        declare EXCEPTIONS_TEMP

        let "c = 0"
        for i in $@
        do
            let "c = ${c} + 1"

            if [ "${i}" = "except" ]
            then
                let "pos = ${c}"
            elif [ "${i}" = "except:" ]
            then
                DEFAULT=True
                let "pos = ${c}"
            fi
        done

        let "d = 0"
        for i in $@
        do
            let "d = ${d} + 1"

            if [ "${d}" -lt "${pos}" ]
            then
                ARGUMENTS+=($i)
            elif [ "${d}" -gt "${pos}" ]
            then
                EXCEPTIONS_TEMP+=($i)
            fi
        done

        let "e = 0"
        for exc in "${EXCEPTIONS_TEMP[@]}"
        do
            let "e = ${e} + 1"

            if [ "${exc: -1}" = ":" ]
            then
                let "end = ${e}";
            fi
        done

        let "f = 0"
        for exc in "${EXCEPTIONS_TEMP[@]}"
        do
            let "f = ${f} + 1"

            if [ "${DEFAULT}" = "True" ]
            then
                CODE+=($exc)
            else
                if [ "${f}" -lt "${end}" ]
                then
                    EXCEPTIONS+=($exc)
                elif [ "${f}" = "${end}" ]
                then
                    EXCEPTIONS+=(${exc%:})
                else
                    CODE+=($exc)
                fi
            fi
        done

        STATUS=$(eval "${ARGUMENTS[@]}" > /dev/null 2>&1;)

        if [ "${?}" = "0" ]
        then
             return 0
        else
            if [ "${DEFAULT}" = "True" ]
            then
                eval "${CODE[@]}"
            else
                if [ "${?}" = "127" ]
                then
                    for EXCEPTION in "${EXCEPTIONS[@]}"
                    do
                        if [ "${EXCEPTION}" = "CommandError" ]
                        then
                            eval "${CODE[@]}"
                        else
                            true
                        fi;
                    done;
                elif [ "${?}" = "2" ]
                then
                    for EXCEPTION in "${EXCEPTIONS[@]}"
                    do
                        if [ "${EXCEPTION}" = "BuiltinError" ]
                        then
                            eval "${CODE[@]}"
                        else
                            true
                        fi;
                    done;
                elif [ "${?}" = "126" ]
                then
                    for EXCEPTION in "${EXCEPTIONS[@]}"
                    do
                        if [ "${EXCEPTION}" = "InvocationError" ]
                        then
                            eval "${CODE[@]}"
                        else
                            true
                        fi;
                    done;
                elif [ "${?}" = "128" ]
                then
                    for EXCEPTION in "${EXCEPTIONS[@]}"
                    do
                        if [ "${EXCEPTION}" = "ExitError" ]
                        then
                            eval "${CODE[@]}"
                        else
                            true
                        fi;
                    done;
                elif [ "${?}" -gt "128" ]
                then
                    for EXCEPTION in "${EXCEPTIONS[@]}"
                    do
                        if [ "${EXCEPTION}" = "FatalError" ]
                        then
                            eval "${CODE[@]}"
                        else
                            true
                        fi;
                    done;
                fi;
            fi;
        fi;

        echo "${EXCEPTIONS_TEMP[@]}"

        if [ -n "${VERBOSE}" ]
        then
            if [ "${VERBOSE}" = "True" ]
            then
                echo -n "Arguments: ";
                echo -e "\e[33m${ARGUMENTS[@]} \e[0m ";
                echo -n "Exceptions: ";
                echo -e "\e[31m\e[5m${EXCEPTIONS[@]} \e[0m ";
                echo -n "Code: ";
                echo -e "\e[32m${CODE[@]} \e[0m ";
            fi
        fi
}

speak()
{
#
# Description:
#
# Syntax:
#
#
        if [ -e ${___CON_ION___}/speaker ]
        then
            for i in $@
            do
                echo "$i" >> ${___SIG_SAY___}
            done
        fi
}

exists()
{
#
# Description:
#
# Syntax:
#
#
        if [ "${1}" = "--dir" ]
        then
            shift 1
            for ADDRESS in $@
            do
                if [ ! -e ${ADDRESS} ]
                then
                    mkdir -p "${ADDRESS}"
                    if [ -e ${ADDRESS} ]
                    then
                        echo True
                        return 0
                    else
                        echo False
                        return 1
                    fi
                else
                    echo True
                    return 0
                fi
            done
        else
            for ADDRESS in $@
            do
                if echo "$ADDRESS" | grep -qo "\."
                then
                    local FILE=${ADDRESS##*/}
                    local TAIL=${FILE%.*}
                    if [ "${TAIL}" = "" ]
                    then
                        EXTENSION=""
                    else
                        EXTENSION=${FILE##*.}
                    fi
                else
                    local EXTENSION=""
                fi

                if [ "${EXTENSION}" != "" ]
                then
                    local PARENT=${ADDRESS%/*}

                    if [ ! -e ${ADDRESS} ]
                    then
                        if [ ! -e ${PARENT} ]
                        then
                            mkdir -p ${PARENT}
                        fi
                        if [ -d ${PARENT} ]
                        then
                            touch ${ADDRESS}
                            if [ -e ${ADDRESS} ]
                            then
                                echo True
                                return 0
                            else
                                echo False
                                return 1
                            fi
                        else
                            echo False
                            return 1
                        fi
                    else
                        echo True
                        return 0
                    fi
                else
                    if [ -d ${ADDRESS} ]
                    then
                        echo True
                        return 0
                    else
                        mkdir -p ${ADDRESS}
                        if [ -d ${ADDRESS} ]
                        then
                            echo True
                            return 0
                        else
                            echo False
                            return 1
                        fi
                    fi
                fi
            done
        fi
}

extension()
{
#
# Description:
#
# Syntax:
#        extension <P>
#
        local P="${1}";

        if echo "$P" | grep -qo "\."
        then
            local FILE=${P##*/}
            local TAIL=${FILE%.*}
            if [ "${TAIL}" = "" ]
            then
                EXTENSION=""
            else
                EXTENSION=${FILE##*.}
            fi
        else
            local EXTENSION=""
        fi

        echo ${EXTENSION};
}

count()
{
#
# Description:
#
# Syntax:
#        current <WHAT> <CURRENT ELEMENT>
#
        if [ "${1}" = "--files" ]
        then
            if [ -d ${2} ]
            then
                let "files = 0"
                for i in ${2}/*
                do
                    if [ -f ${i} ]
                    then
                        let "files = $files + !"
                    fi
                done
                echo $files
            fi
        elif [ "${1}" = "--certain-files" ]
        then
            if [ -d ${2} ]
            then
                if [ -n ${3} ]
                then
                    let "files = 0"
                    for i in ${2}/*${3}
                    do
                        if [ -f ${i} ]
                        then
                            let "files = $files + !"
                        fi
                    done
                    echo $files
                fi
            fi
        elif [ "${1}" = "--arguments" ]
        then
            shift 1
            let "arguments = 0"
            for j in "${@}"
            do
                if [ "${j:0:2}" != "--" ]
                then
                    let "arguments = $arguments + !"
                fi
            done
            echo $arguments
        fi
}

odd()
{
#
# Description: Checks if an integer is an odd number.
#
# Syntax:
#        odd <INTEGER>
#
        if [ -n ${1} ]
        then
            if [[ "$1" =~ "^[0-9]+$" ]]
            then
                local NUM="${1}";
            fi
        fi

        if [ -n ${NUM} ]
        then
            let "MOD = ${1} % 2"

            if [ "${MOD}" = "0" ]
            then
                echo False
            else
                echo True
            fi
        else
            echo "Invalid input. Accepting only integers."
        fi
}

even()
{
#
# Description: Checks if an integer is an even number.
#
# Syntax:
#        even <INTEGER>
#

        if [[ "${1}" =~ "^[0-9]+$" ]]
        then
            local NUM="${1}";
        fi

        if [ -n ${NUM} ]
        then
            let "MOD = ${NUM} % 2"

            if [ "${MOD}" = "0" ]
            then
                echo True
            else
                echo False
            fi
        else
            echo "Invalid input. Accepting only integers."
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
