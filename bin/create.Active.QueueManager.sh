#:/bin/sh

# ------------------------------------------------------------------------- 
# Copyright (c) 2014 Lorenco Trichardt, Ashley Fernandez
# Released under the GNU GENERAL PUBLIC LICENSE (Version 3)
# https://github.com/giphos/classic-iib-shell-scripts
#
# Version		: 1.0
#
# Problems 	: Deprecated ...
#
# TODO 		: 
# -------------------------------------------------------------------------

# include all multi-instance source library
source ../lib/iib_scriptLib.sh

# Global variables for this script  USE PROPERTIES HERE ....
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_CMDMODE="echo"

if [ $# = 1 ]
then 
	_QMGRNAME=$1
else 
	log "E Queue manager Name Expected"
	exit 1
fi

# BEGIN
# Create Active Queue Manager
log "I Creating Active multi-instance queue manager ${_QMGRNAME}"
crtmqm -ld ${_MQMSHAREDATA}/logs/ -md ${_MQMSHAREDATA}/qmgrs -q ${_QMGRNAME}

# Start Active Queue Manager
log "I Starting ${_QMGRNAME}"
strmqm -x ${_QMGRNAME}

# Displaying status of queue manager
log "I Queue manager status..."
dspmq -x -m ${_QMGRNAME}
# END
