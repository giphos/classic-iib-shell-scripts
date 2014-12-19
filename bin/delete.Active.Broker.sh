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

# Global variables for this script USE PROPERTIED FILE TODO
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_WMBSHAREDATA="/opt/ibm/shared/wmq"

if [ $# = 1 ]
then 
	_BRKNAME=$1
else
	log "E Missing Broker Name"
	log "I $0 <BrokerName>"
	exit 1
fi

# BEGIN

# Stop Active Broker
log "I Stopping Active Broker ${_BRKNAME}"
mqsistop ${_BRKNAME}

read -p "Stop and Delete Standby Broker ${_BRKNAME} on the standby host : "

# Delete Active Broker
log ""
log "I Delete Active Broker ${_BRKNAME}"
mqsideletebroker ${_BRKNAME}

# Display Broker status
log ""
log "I Display Broker status ${_BRKNAME} "
mqsilist ${_BRKNAME} 

# Display message to delete the Queue manager
log " Now delete the Active/Standby Queue manager that was used by the multi-instance Broker(${_BRKNAME}"
# END
