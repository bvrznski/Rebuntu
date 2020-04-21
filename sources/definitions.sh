#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /SOURCES/DEFINITIONS.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:		System-wide variable declarations.
#
# ROLE:		address pointing
#
# REALM:	global
#
# DOMAIN:	reference
#
# LIST:		definitions
#
# DONE: ✓

#------------------------------

definitions()
{
#
# Description:
#
# Syntax:
#		 definitons --imported
#
    if [ "${1}" = "--sourced" ]
    then
        echo True
    fi
}

#------------------------------

if env | grep -qo "RUN"
then
    if [ "${RUN}" != "" ]
    then
        RUNTIME="${RUN}"
    else
        RUNTIME="${HOME}/.rebuntu"
    fi
else
    RUNTIME="${HOME}/.rebuntu"
fi

# runtime
___RUN_LED___="${RUNTIME}/ledgers"
# controller
___CON_LOK___="${RUNTIME}/controller/lock"
___CON_ACT___="${RUNTIME}/controller/active"
___CON_INA___="${RUNTIME}/controller/inactive"
___CON_ION___="${RUNTIME}/controller/on"
___CON_OFF___="${RUNTIME}/controller/off"
___CON_ENA___="${RUNTIME}/controller/enabled"
___CON_DIS___="${RUNTIME}/controller/disabled"
___CON_RUN___="${RUNTIME}/controller/run"
___CON_RNS___="${RUNTIME}/controller/runs"
___CON_SIG___="${RUNTIME}/controller/signal"
___CON_VAR___="${RUNTIME}/controller/various"
___CON_STA___="${RUNTIME}/controller/state"
___CON_SAV___="${RUNTIME}/controller/save"
# inputs
___INC_FRO___="${RUNTIME}/bus/in/from"
___INC_WHA___="${RUNTIME}/bus/in/what"
___INC_WIT___="${RUNTIME}/bus/in/with"
___INC_WHE___="${RUNTIME}/bus/in/when"
___INC_WHO___="${RUNTIME}/bus/in/whom"
___INC_DAT___="${RUNTIME}/bus/in/data"
# outputs
___OUT_FRO___="${RUNTIME}/bus/out/from"
___OUT_WHA___="${RUNTIME}/bus/out/what"
___OUT_WIT___="${RUNTIME}/bus/out/with"
___OUT_WHE___="${RUNTIME}/bus/out/when"
___OUT_WHO___="${RUNTIME}/bus/out/whom"
___OUT_DAT___="${RUNTIME}/bus/out/data"
# registers
___REG_FRE___="${RUNTIME}/registers/frequency.sh"
___REG_EXE___="${RUNTIME}/registers/execution.sh"
___REG_TRE___="${RUNTIME}/registers/tresholds.sh"
# timng
___TIM_TIM___="${RUNTIME}/timing/timed"
___TIM_DEL___="${RUNTIME}/timing/delayed"
___TIM_ELI___="${RUNTIME}/timing/elicited"
___TIM_TRI___="${RUNTIME}/timing/triggered"
# personalization
___USR_SET___="${RUNTIME}/user/settings.sh"
# signals
___SIG_SAY___="${___CON_SIG___}/SAY"
# library
___LIB_LST___="${REBUNTU}/library/lists"
___LIB_LIN___="${REBUNTU}/library/links"
___LIB_PKG___="${REBUNTU}/library/packages"
___LIB_APT___="${REBUNTU}/library/packages/apt"
___LIB_PIP___="${REBUNTU}/library/packages/snap"
___LIB_SNA___="${REBUNTU}/library/packages/pip"
___LIB_NPM___="${REBUNTU}/library/packages/npm"
___LIB_APM___="${REBUNTU}/library/packages/apm"
___LIB_REP___="${REBUNTU}/library/repositories"
___LIB_GIT___="${REBUNTU}/library/repositories/git"
___LIB_PPA___="${REBUNTU}/library/repositories/ppa"
___LIB_PAR___="${REBUNTU}/library/parts"
___LIB_BLO___="${REBUNTU}/library/parts/codeblocks"
___LIB_PRO___="${REBUNTU}/library/parts/prototypes"
___LIB_SKE___="${REBUNTU}/library/parts/skeletons"
___LIB_PRE___="${REBUNTU}/library/presets"
___LIB_MOD___="${REBUNTU}/library/presets/mode"
___LIB_SET___="${REBUNTU}/library/presets/setup"
___LIB_THE___="${REBUNTU}/library/presets/theme"
___LIB_SOU___="${REBUNTU}/library/sounds"
___LIB_INT___="${REBUNTU}/library/sounds/interface"
___LIB_VOX___="${REBUNTU}/library/sounds/voice"
___LIB_TEX___="${REBUNTU}/library/texts"
___LIB_TIP___="${REBUNTU}/library/tips"
___LIB_BOA___="${REBUNTU}/library/tips/boards"
___LIB_DIA___="${REBUNTU}/library/tips/diagrams"
___LIB_DIC___="${REBUNTU}/library/tips/dictionaries"
___LIB_SCH___="${REBUNTU}/library/tips/schemes"
___LIB_TAB___="${REBUNTU}/library/tips/tables"

#-------------------------------------------------------------------------------------------------#
############|                                                                      |              #
########|   |                                                                  	   |              #
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
