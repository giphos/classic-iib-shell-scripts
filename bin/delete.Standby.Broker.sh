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

# Global variables for this script CHANGE TO USE PROPERTY FILES TODO
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_WMBSHAREDATA="/opt/ibm/shared/wmq/"

_CMDMODE="echo"
if [ $# = 1 ]
then 
	_BRKNAME=$1
else
	log "E BrokerName missing"
	log "I $0 <BrokerName>"
	exit 1
fi

# BEGIN

# Add Standby Queue Manager
log "I Stopping Standby Broker ${_BRKNAME}"
mqsistop ${_BRKNAME}

log "I Sleeping for Five ticks to let the broker quiesce"
sleep 5

# Delete the broker instance
log "I Removing broker instance"
mqsiremovebrokerinstance ${_BRKNAME}

# display status
log "I Standby Broker Status"
mqsilist

log ""
log "I You can now proceed to delete the Active Broker Instance"
log ""
