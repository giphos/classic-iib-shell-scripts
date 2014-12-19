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

# Global variables for this script - PROPERTIES FILE
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_WMBSHAREDATA="/opt/ibm/shared/wmq"

if [ $# = 2 ]
then 
	_QMGRNAME=$1
	_BRKNAME=$2
else
	log "E Queue Manager Name or Broker Name missing"
	log "I $0 <QueueManagerName> <BrokerName>"
	exit 1
fi

# BEGIN

# Create Queue Manager
sh ./create.Standby.QueueManager.sh ${_QMGRNAME}

# Add Broker instance 
log  " "
log "I Adding broker Instance ${_BRKNAME}"
mqsiaddbrokerinstance ${_BRKNAME} -e ${_WMBSHAREDATA}

# Start Broker instance 
log  " "
log "I Starting broker Instance ${_BRKNAME}"
mqsistart ${_BRKNAME}

# Add Broker instance
log " "
log "I Display status broker instance ${_BRKNAME}"
mqsilist ${_BRKNAME}
# END
