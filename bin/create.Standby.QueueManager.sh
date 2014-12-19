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

# Global variables for this script PROPERTIES FILE TODO
_MQMSHAREDATA="/opt/ibm/shared/wmq/mq"

if [ $# = 1 ]
then 
	_QMGRNAME=$1
else
	log "E Queue manager Name missing!"
	log "I $0 <QueueManageName>"
	exit 1
fi

# BEGIN

# Add Standby Queue Manager
log "I Adding standby instance for queue manager ${_QMGRNAME}"
addmqinf -v Name=${_QMGRNAME} -v Directory=${_QMGRNAME} -v Prefix=/var/mqm -v DataPath=${_MQMSHAREDATA}/qmgrs/${_QMGRNAME}

# start Active Queue Manager
log "I Starting ${_QMGRNAME}"
strmqm -x ${_QMGRNAME}

# Display Queuemanger status
log "I Display Status ${_QMGRNAME}"
dspmq -x -m ${_QMGRNAME}
# END
