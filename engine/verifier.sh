#!/bin/bash
#─────────────────────────────────────────────────────────────────────────────────────────────────#
#                                                                                                 #
#                                           V E R I F I E R                                       #
#                                                                                                 #
#─────────────────────────────────────────────────────────────────────────────────────────────────#
#
# TASK: Examine the system's integrity.
#
# PART: engine
#
# CALL: loader
#
# DONE: ✓

main()
{

    local FHS=( /bin /boot /dev /etc /home /lib /media /mnt /opt /proc /root /run /sbin /srv /sys \
                /tmp /usr /var )

    imports()
    {
            # 'importing internal functions'
            #-----------------------------------------------------------------------
            if [ -e ${REBUNTU}/internal/modes.sh ]
            then  . ${REBUNTU}/internal/modes.sh; fi;
            if [ -e ${REBUNTU}/internal/parts.sh ]
            then  . ${REBUNTU}/internal/parts.sh; fi;
            if [ -e ${REBUNTU}/sources/definitions.sh ]
            then  . ${REBUNTU}/sources/definitions.sh; fi;
            if [ -e ${REBUNTU}/sources/language.sh ]
            then  . ${REBUNTU}/sources/language.sh; fi;
            #-----------------------------------------------------------------------
    }

    structures()
    {                                                                               debug --stage \
            'examining structural integrity'
            #-----------------------------------------------------------------------
            if env | grep -qo "GIT="
            then
                [ -d ${GIT} ] || mkdir -p ${GIT}
            fi

            if env | grep -qo "MAN="
            then
                [ -d ${MAN} ] || mkdir -p ${MAN}
            fi

            if env | grep -qo "RUN="
            then
                [ -d ${RUN} ] || mkdir -p ${RUN}
            fi

            while read LINE
            do
            	PREF="${LINE:0:3}";

            	if [ "${PREF}" = "___" ]
            	then
            		VARIABLE="${LINE%%=*}";
            		VALUE="${LINE##*=}";
            		VAR=$(eval "echo ${VALUE}");

            	    TYP="${LINE:3:3}";

            		if [ "${TYP}" = "CON" ]
            		then
                        exists --dir "${VAR}" > /dev/null 2>&1;
                        [ "$?" = "0" ] || FILES=False;
            		elif [ "${TYP}" = "RUN" ]
            		then
                        exists --dir "${VAR}" > /dev/null 2>&1;
            		elif [ "${TYP}" = "MON" ]
            		then
                        exists --dir "${VAR}" > /dev/null 2>&1;
            		elif [ "${TYP}" = "INC" ]
            		then
                        exists --dir "${VAR}" > /dev/null 2>&1;
                        [ "$?" = "0" ] || FILES=False;
            		elif [ "${TYP}" = "OUT" ]
            		then
                        exists --dir "${VAR}" > /dev/null 2>&1;
                        [ "$?" = "0" ] || FILES=False;
            		elif [ "${TYP}" = "REG" ]
            		then
                        exists "${VAR}" > /dev/null 2>&1;
                        [ "$?" = "0" ] || FILES=False;
            		elif [ "${TYP}" = "TIM" ]
            		then
                        exists "${VAR}" > /dev/null 2>&1;
                        [ "$?" = "0" ] || FILES=False;
            	    fi;
                fi;

            done < ${REBUNTU}/sources/definitions.sh;

            [ "${FILES}" = "True" ] && RESULT=True || RESULT=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    registers()
    {                                                                               debug --stage \
            'examining registers integrity'
            #-----------------------------------------------------------------------
            while read LINE
            do
            	PREF="${LINE:0:3}";

            	if [ "${PREF}" = "___" ]
            	then
            		VARIABLE="${LINE%%=*}";
            		VALUE="${LINE##*=}";
            		VAR=$(eval "echo ${VALUE}");

            	    TYP="${LINE:3:3}";

            		if [ "${TYP}" = "REG" ]
            		then
                        for UNI in ${REBUNTU}/units/*
                        do
                            UNIT="${UNI##*/}"
                            NAME="${UNIT%.*}"

                            if ! cat ${VAR} | grep -qo "${NAME}:"
                            then
                                echo "${NAME}:" >> ${VAR}
                            fi
                        done
                    fi
                fi
            done < ${REBUNTU}/sources/definitions.sh;

            [ -e "${S}" ] && RESULT=True || RESULT=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    settings()
    {                                                                               debug --stage \
            'examine settings integrity'
            #-----------------------------------------------------------------------
            for f in $(parser ${REBUNTU}/units '(setting [A-Z]' '[^ "][A-Z]*[A-Z]');      # (parser)
            do
                F=$(echo ${f} | sed -e 's/\(.*\)/\U\1/')
                grep -qo "${F}" ${___USR_SET___} \
                 || echo "${F}=" >> ${___USR_SET___};
            done;

            [ -e "${___USR_SET___}" ] && RESULT=True || RESULT=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    bookmarks()
    {                                                                               debug --stage \
            'examining bookmarks adequacy'
            #-----------------------------------------------------------------------
            [ -e ${HOME}/.config/gtk-3.0/bookmarks ] \
            && rm ${HOME}/.config/gtk-3.0/bookmarks
            [ -e ${HOME}/.config/gtk-3.0/bookmarks ] \
            || touch ${HOME}/.config/gtk-3.0/bookmarks

            for dir in ${HOME}/*
            do
                if [ -d "${dir}" ]
                then
                    if [ "${dir}" != "${HOME}/snap" ] \
                    && [ "${dir}" != "${HOME}/Steam" ]
                    then
                        echo "file://${dir}" >> ${HOME}/.config/gtk-3.0/bookmarks
                        [ "$?" = "0" ] || BOOKMARKS=False
                    fi
                fi
            done

            for dir in /mnt/*
            do
                echo "file://${dir}" >> ${HOME}/.config/gtk-3.0/bookmarks
                [ "$?" = "0" ] || BOOKMARKS=False
            done

            [ "${BOOKMARKS}" != "False" ] && RESULT=True || RESULT=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    run() { imports; structures; registers; bookmarks; }; run;
}

if printenv | grep -qo "DEBUG=True"; then DEBUG=True
                                     else DEBUG=False; fi;

if printenv | grep -qo "REBUNTU"
then
    main
fi

#-------------------------------------------------------------------------------------------------#
####        |                                                                      |              #
#   ########|                                                                      |              #
#           #######################################################################|              #
#                                                                                  ################
#-------------------------------------------------------------------------------------------------#
