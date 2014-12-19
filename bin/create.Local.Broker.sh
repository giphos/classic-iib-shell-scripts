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

# Global variables for this script -CHANGE USE PROPERTIES!!!
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_WMBSHAREDATA="/opt/ibm/shared/wmq"

if [ $# = 2 ]
then 
	_QMGRNAME=$1
	_BRKNAME=$2
else
	log "E Missing broker name and/queue manager name"
	log "I $0 <QueueManagerName> <BrokerName>"
	log ""
	exit 1
fi

# BEGIN

# Create Active Queue Manager
sh ./create.Local.QueueManager.sh ${_QMGRNAME}

#Create Active Broker
log " "
log "I Creating Active Broker ${_BRKNAME}"
mqsicreatebroker ${_BRKNAME} -q ${_QMGRNAME}

#start Active Broker
log " "
log "I Creating Active Broker ${_BRKNAME}"
mqsistart ${_BRKNAME}

# Display Broker status
log " "
log "I Display Broker status ${_BRKNAME}"
mqsilist  ${_BRKNAME} 
# END
