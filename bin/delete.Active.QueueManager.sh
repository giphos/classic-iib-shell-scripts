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

# Global variables for this script USE PROPERTIES FILE
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"
_CMDMODE="echo"

if [ $# = 1 ]
then 
	_QMGRNAME=$1
else
	log "E Missing queue manager name"
	log "I $0 <queue manager name>"
	exit 1
fi

# BEGIN
# Stop Active Queue Manager
log "I Stopping Active multi-instance queue manager ${_QMGRNAME}"
endmqm ${_QMGRNAME}

# Waiting to end normally... 
log "I Sleeping for ten seconds to let queue manager end normally ${_QMGRNAME}"
sleep 10

# Deleting the bugger...
dltmqm ${_QMGRNAME}

# Displaying status of queue manager
log ""
log "I Queue manager status..."
dspmq -x 
log ""
# END
