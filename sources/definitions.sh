#!/bin/bash

# -----------------------------------  GLOSSARY  -----------------------------------
#
# ----------------------------------------------------------------------------------

REBUNTU_SOURCE=/opt/rebuntu
REBUNTU_BINARIES=/bin/rebuntu
REBUNTU_PROFILES=/usr/rebuntu
REBUNTU_CONFIGS=/etc/rebuntu
REBUNTU_RUNTIME=/var/rebuntu
REBUNTU_DATAFLOW=/tmp/rebuntu
REBUNTU_LIBRARY=/lib/rebuntu

# ------------------------------

MAINFRAME=$REBUNTU_RUNTIME/.mainframe
REGISTER=$REBUNTU_RUNTIME/.register
CONSOLE=$REBUNTU_RUNTIME/.console

# ------------------------------

FHS=(   '/bin'
        '/boot'
        '/dev'
        '/etc'
        '/home'
        '/lib'
        '/media'
        '/mnt'
        '/opt'
        '/proc'
        '/root'
        '/run'
        '/sbin'
        '/srv'
        '/sys'
        '/tmp'
        '/usr'
        '/var'
    )

SYS=(   '/bin'
        '/sbin'
        '/dev'
        '/proc'
        '/sys'
        '/boot'
        '/root'
        '/run'
        '/lost+found'
    )

# ------------------------------
