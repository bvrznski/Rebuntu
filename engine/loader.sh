#!/bin/bash
#─────────────────────────────────────────────────────────────────────────────────────────────────#
#                                                                                                 #
#                                           L O A D E R                                           #
#                                                                                                 #
#─────────────────────────────────────────────────────────────────────────────────────────────────#
#
# TASK: Load all definitions and structures necessary for systm's functionality.
#
# PART: engine
#
# CALL: .rebunturc
#
# DONE: ✓

main()
{
    imports()
    {
            # 'importing internal functions'
            #-----------------------------------------------------------------------
            if [ -e ${REBUNTU}/internal/modes.sh ]
            then  . ${REBUNTU}/internal/modes.sh; fi;
            #-----------------------------------------------------------------------
    }

    exports()
    {                                                                               debug --stage \
            'exporting environmental variables'
            #-----------------------------------------------------------------------
            if __GIT__="$(l1=$(grep "GITHUB=" /etc/rebuntu.conf); l2=${l1##*=}; echo "${l2}")";
            then export GIT="${__GIT__}"; fi;
                      env | grep -qo "GIT" || RESULT=False;
            if __MAN__="$(l1=$(grep "MANAGER=" /etc/rebuntu.conf); l2=${l1##*=}; echo "${l2}")";
            then export MAN="${__MAN__}"; fi;
                      env | grep -qo "MAN" || RESULT=False;
            if __RUN__="$(l1=$(grep "RUNTIME=" /etc/rebuntu.conf); l2=${l1##*=}; echo "${l2}")";
            then export RUN="${__RUN__}"; fi;
                      env | grep -qo "RUN" || RESULT=False;

            if [ -d "$(xdg-user-dir DOWNLOAD)" ]
            then export DL="$(xdg-user-dir DOWNLOAD)"; fi;
                      env | grep -qo "DL" || RESULT=False;

            [ "${RESULT}" = "False" ] && LOADING=False || RESULT=True;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    additions()
    {                                                                               debug --stage \
            'adding loader to rebunturc'
            #-----------------------------------------------------------------------
            if [ "${0}" != "/bin/bash" ]
            then
                if grep -qo "${0}" ${HOME}/.rebunturc;
                then
                    true
                else
                    echo >> ${HOME}/.rebunturc
                    echo "# REBUNTU #" >> ${HOME}/.rebunturc
                    echo >> ${HOME}/.rebunturc
                    echo "if [ -f ${0} ];" >> ${HOME}/.rebunturc;
                    echo "then . ${0}; fi;" >> ${HOME}/.rebunturc;
                fi;
            fi;

            grep -qo "/engine/loader.sh" ${HOME}/.rebunturc && RESULT=True || RESULT=False;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status

                                                                                    debug --stage \
            'adding sources to rebunturc'
            #-----------------------------------------------------------------------
            if cat ${HOME}/.rebunturc | grep -qo ".sources.sh"
            then
                true
            else
                echo >> ${HOME}/.rebunturc
                echo 'if [ -f ${HOME}/.sources.sh ]' >> ${HOME}/.rebunturc;
                echo 'then . ${HOME}/.sources.sh; fi;' >> ${HOME}/.rebunturc; fi;

            if cat ${HOME}/.rebunturc | grep -qo ".sources.sh";
            then RESULT=True;
            else RESULT=False; fi;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status

                                                                                    debug --stage \
            'adding rebunturc to bashrc'
            #-----------------------------------------------------------------------
            if cat ${HOME}/.bashrc | grep -qo "rebunturc"
            then
                true
            else
                echo >> ${HOME}/.bashrc
                echo 'if [ -e ${HOME}/.rebunturc ]' >> ${HOME}/.bashrc;
                echo 'then . ${HOME}/.rebunturc; fi;' >> ${HOME}/.bashrc; fi;

            if cat ${HOME}/.bashrc | grep -qo "rebunturc"
            then RESULT=True;
            else RESULT=False; fi;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    loadings()
    {                                                                               debug --stage \
            'loading definitions'
            #-----------------------------------------------------------------------
            [ -e ${REBUNTU}/sources/definitions.sh ] \
            && . ${REBUNTU}/sources/definitions.sh;

            [ "$?" = "0" ] && RESULT=True || RESULT=False;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status

    }

    creations()
    {                                                                               debug --stage \
            'creating ~/.sources.sh file'
            #-----------------------------------------------------------------------
            echo  '#!/bin/bash' > ${HOME}/.sources.sh;

            echo ". ${REBUNTU}/system/import.sh" >> ${HOME}/.sources.sh;

            for SOURCE in ${REBUNTU}/sources/*
            do
                if [ -f ${SOURCE} ]
                then
                    if [ "${SOURCE##*.}" = "sh" ]; then
                        if [ "$(t=${SOURCE##*/}; echo ${t%.*})" != "__info__" ]; then
                            echo  ". ${SOURCE}" >> ${HOME}/.sources.sh;
                            grep -qo ". ${SOURCE}" ${HOME}/.sources.sh \
                            || ASSUME_COMPLETE=False; fi; fi; fi; done;

            [ "${ASSUME_COMPLETE}" = "False" ] && RESULT=False || RESULT=True;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    sources()
    {                                                                               debug --stage \
            'source from ~/.sources.sh'
            #-----------------------------------------------------------------------
            if [ -e ~/.sources.sh ];
            then . ~/.sources.sh; fi;

            [ "$?" = "0" ] && RESULT=True || RESULT=False;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    requests()
    {                                                                               debug --stage \
            'requesting examination by the verifier'
            #-----------------------------------------------------------------------
            if [ -e ${REBUNTU}/engine/verifier.sh ];
            then
                bash ${REBUNTU}/engine/verifier.sh
            fi;

            [ "${?}" = "0" ] && RESULT=True || RESULT=False;

            [ "${RESULT}" = "False" ] && LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status

                                                                                    debug --stage \
            'requesting the core launch'
            #-----------------------------------------------------------------------
            [ -e ${REBUNTU}/engine/core.sh ] && bash ${REBUNTU}/engine/core.sh;

            sleep 0.1

            [ "$?" = "0" ] && RESULT=True || RESULT=False;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status

                                                                                    debug --stage \
            'requesting the admin launch'
            #-----------------------------------------------------------------------
            [ -e ${REBUNTU}/engine/admin.sh ] && bash ${REBUNTU}/engine/admin.sh;

            sleep 0.1

            [ "$?" = "0" ] && RESULT=True || RESULT=False;

            [ "${RESULT}" = "True" ] || LOADING=False;
            #-----------------------------------------------------------------------
                                                                                    debug --status
    }

    run() { imports; exports; additions; loadings; creations; sources; requests; }; run;
}

if [ -e /etc/rebuntu.conf ]
then
    if __REB__="$(l1=$(grep "REBUNTU_LOCATION=" /etc/rebuntu.conf);
                  l2=${l1##*=}; echo "${l2}")";
    then
        export REBUNTU="${__REB__}";

        declare LOADING=True;

        if printenv | grep -qo "DEBUG=True"; then DEBUG=True
                                             else DEBUG=False; fi;

        if printenv | grep -qo "REBUNTU"
        then
            main
        fi


        if [ "${LOADING}" = "True" ];
        then
            echo -e "\e[34m\e[5m\e[1m ╭─────────────────────────────────────────────────────╮"
            echo -e "\e[34m\e[5m\e[1m │ R E B U N T U  L O A D E D  S U C C E S S F U L L Y │"
            echo -e "\e[34m\e[5m\e[1m ╰─────────────────────────────────────────────────────╯"
        else
            echo -e "\e[91m\e[5m\e[1m ╭────────────────────────────────────────────────────╮"
            echo -e "\e[91m\e[5m\e[1m │ R E B U N T U  L O A D E D  W I T H  E R R O R S ! │"
            echo -e "\e[91m\e[5m\e[1m ╰────────────────────────────────────────────────────╯"
        fi;
    else
        echo -e "\e[31m\e[5m\e[1m ╭────────────────────────────────────────────────────╮"
        echo -e "\e[31m\e[5m\e[1m │ R E B U N T U  C O N F I G  F I L E  B R O K E N ! │"
        echo -e "\e[31m\e[5m\e[1m ╰────────────────────────────────────────────────────╯"
    fi;
else
    echo -e "\e[31m\e[5m\e[1m ╭────────────────────────────────────────────────────╮"
    echo -e "\e[31m\e[5m\e[1m │ R E B U N T U  C O N F I G  F I L E  M I S I N G ! │"
    echo -e "\e[31m\e[5m\e[1m ╰────────────────────────────────────────────────────╯"
fi;

#-------------------------------------------------------------------------------------------------#
####        |                                                                      |              #
#   ########|                                                                      |              #
#           #######################################################################|              #
#                                                                                  ################
#-------------------------------------------------------------------------------------------------#
