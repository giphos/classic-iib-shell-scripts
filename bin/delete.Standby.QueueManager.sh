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

# Global variables for this script CHANGE PROPERTIES FILES TODO
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_CMDMODE="echo"

if [ $# = 1 ]
then 
	_QMGRNAME=$1
else
	log "E Queue Manager name missing"
	log "I $0 <Queue manager Name>"
	exit 1
fi

# BEGIN

# Stop the Queue manager
log "I Stopping ${_QMGRNAME}"
endmqm ${_QMGRNAME}
log ""

# Add Standby Queue Manager
log "I Removing standby instance for queue manager ${_QMGRNAME}"
rmvmqinf ${_QMGRNAME}
log ""

# Display Queuemanger status
log ""
log "I Display ${_QMGRNAME}"
dspmq -x 
log ""
# END
