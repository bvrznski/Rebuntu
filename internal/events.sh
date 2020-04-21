#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/EVENTS.SH
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
# LIST:		warning, alert, change, login,
#
# DONE: ✓

#---------------------------------------

events()
{
# Syntax:
#		 events --imported
#
		if [ "${1}" = "--imported" ]
		then
			echo True
		fi
}

#---------------------------------------

error()
{
# Syntax:
#
		true
}

sound()
{
# Syntax:
#
		if [ "${1}" = "--alarm" ]
		then
			aplay ${___LIB_SOU___}/other/alarm.wav
		elif [ "${1}" = "--warning" ]
		then
			aplay ${___LIB_SOU___}/other/warning.wav
		elif [ "${1}" = "--alarm" ]
		then
			aplay ${___LIB_SOU___}/interface/alarm.wav
		elif [ "${1}" = "--acquired" ]
		then
			aplay ${___LIB_SOU___}/interface/acquired.wav
		elif [ "${1}" = "--add" ]
		then
			aplay ${___LIB_SOU___}/interface/add.wav
		elif [ "${1}" = "--affirmative" ]
		then
			aplay ${___LIB_SOU___}/interface/affirmative.wav
		elif [ "${1}" = "--button" ]
		then
			aplay ${___LIB_SOU___}/interface/button.wav
		elif [ "${1}" = "--error" ]
		then
			aplay ${___LIB_SOU___}/interface/error.wav
		elif [ "${1}" = "--finished" ]
		then
			aplay ${___LIB_SOU___}/interface/finished.wav
		elif [ "${1}" = "--increase" ]
		then
			aplay ${___LIB_SOU___}/interface/increase.wav
		elif [ "${1}" = "--information" ]
		then
			aplay ${___LIB_SOU___}/interface/information.wav
		elif [ "${1}" = "--negative" ]
		then
			aplay ${___LIB_SOU___}/interface/negative.wav
		elif [ "${1}" = "--news" ]
		then
			aplay ${___LIB_SOU___}/interface/news.wav
		elif [ "${1}" = "--notification" ]
		then
			aplay ${___LIB_SOU___}/interface/notification.wav
		elif [ "${1}" = "--objective" ]
		then
			aplay ${___LIB_SOU___}/interface/objective.wav
		elif [ "${1}" = "--off" ]
		then
			aplay ${___LIB_SOU___}/interface/off.wav
		elif [ "${1}" = "--on" ]
		then
			aplay ${___LIB_SOU___}/interface/on.wav
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
