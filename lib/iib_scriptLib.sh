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

log()
{
	if test "$*" = ""
	then
		echo
	else
		_TIMESTAMP=`date`
		echo $_TIMESTAMP $*
	fi
}

dieWithMessage()
{
	if ! test "$*" = ""
	then
		log $*
		exit 1
	fi
}

dieIfNULL()
{
	_VAR=$1
	_VARNAME=$2
	if test -z "$_VAR"
	then
		dieWithMessage "E mandatory [$_VARNAME] is null"
	fi
}


sanityCheckProperties()
{
	log "I >>sanitycheckProperties $*"

	_MODE=$1
	_FILENAME=$2

	checkFileExist $_MODE $_FILENAME

	while read _LINE
	do
		if ! test -z "$_LINE"
		then
			_COMMENT=`echo $_LINE | cut -c1`
			if test $_COMMENT != "#"
			then
				_MANDOPTION=`echo $_LINE | cut -c1,2`
				if test $_MANDOPTION = "$iib_MANDATORYFIELDKEY"
				then
					_VALUE=`echo $_LINE | cut -d "=" -f2`
					if test -z $_VALUE
					then
						dieWithMessage "E Empty mandatory field : [$_LINE]"
					fi
				fi
			fi
		fi
	done < $_FILENAME
	log "I <<sanitycheckProperties"
}

intialiseProperties()
{
	log "I >>intialiseProperties $*"
	_MODE=$1
	_PROPFILE=$2
	log "I Using properties file [$_PROPFILE]"

	checkFileExist $_MODE $_PROPFILE
	sanityCheckProperties $_MODE $_PROPFILE
	. $_PROPFILE
	log "I <<intialiseProperties"
}


checkDirectoryDoesNotExist()
{
	_MODE=$1
	_DIR=$2
	log "I Checking for directory existence [$_DIR]"
	if ! test -d "$_DIR"
	then
		dieWithMessage "E [$1] directory does not exist"
	fi
}

checkDirectoryExists()
{
	_MODE=$1
	_DIR=$2
	log "I Checking for directory existence [$_DIR]"
	if test -d "$_DIR"
	then
		
		if test $_MODE = "run"
		then
			dieWithMessage "E [$1] directory exists, bailing..."
		else
			log "E [$1] directory exists, would have bailed if not in echo mode..."
		fi

	fi
}

checkFileExist()
{
	_MODE=$1
	_FILE=$2
	log "I Checking for file existence [$_FILE]"
	if ! test -s $_FILE
	then
		if test $_MODE = "run"
		then
			dieWithMessage "E [$_FILE] file does not exist OR empty"
		else
			log "E [$_FILE] file does not exist OR empty"
		fi
	fi
}

executeCommand()
{
	_MODE=$1
	_COMMAND=$2

	if test -z "$_COMMAND"
	then
		dieWithMessage "E Aborting @ executeCommand, as no command to execute"
	fi

	log "I executeCommand $_MODE $_COMMAND"
	case $_MODE in
		run)
			eval $_COMMAND
			if ! test $? -eq 0
			then
				dieWithMessage "E Command execution FAILED $_COMMAND"
			fi
			;;
			*) 
			;;
	esac
}


createDirectory()
{
	_MODE=$1
	_DIR=$2
	if ! test -d $_DIR
	then
		log "I Creating $_DIR ..."
		executeCommand $_MODE "mkdir -p $_DIR"
	else
		log "I Directory $_DIR already exists nothing to do..."
	fi
}

removeFile()
{
	log "removeFile>>"
	_MODE=$1
	_FILETONIX=$2
	executeCommand $_MODE "rm -f $_FILETONIX"
	log "removeFile<<"
}

runmqscScriptOnQMGR()
{
	log "I >>runmqscScriptOnQMGR $*"
	_MODE=$1
	_QMGR=$2
	_SCRIPTNAME=$3

	checkFileExist $_MODE $_SCRIPTNAME
	_EXISTS=`dspmq | grep $_QMGR |grep Running | wc -l`

	if test $_EXISTS -eq 0
	then
		
		if test $_MODE = "run"
		then
			dieWithMessage "E Queue Manager $_QMGR not running, bailing..."
		else
			log "E Queue Manager $_QMGR not running, would have bailed if not in echo mode..."
		fi
	fi
	log "I Executing script $_SCRIPTNAME on $_SCRIPTNAME" 
	executeCommand $_MODE "runmqsc $_QMGR < $_SCRIPTNAME"

	log "I <<runmqscScriptOnQMGR"
}


updateBarFileWithOverrides()
{
	log "I >>updateBarFileWithOverrides $*"

	_MODE=$1
	_SVCBAR=$2
	_SVCBARPROP=$3

	# updateBarFileWithOverrides $_MODE $m_SVCBAR $m_SVCBARPROP $_UPDATED_BARF
	log "I Updating $_SVCBAR using $_SVCBARPROP creating $_SVCBARPROP for deployment"
	checkFileExist $_MODE $_SVCBAR
	checkFileExist $_MODE $_SVCBARPROP
	executeCommand $_MODE "mqsiapplybaroverride -b $_SVCBAR -p $_SVCBARPROP 2>/dev/null"

	log "I >>updateBarFileWithOverrides"
}

deployBarFileToBrokerWithEG()
{
	log "I >>deployBarFileToBrokerWithEG $*"

	_MODE=$1
	_BROKER=$2
	_EGRP=$3
	_UPDATED_BARF=$4

	log "I Updating $_SVCBAR using $_SVCBARPROP creating $_UPDATED_BARF for deployment"
	checkFileExist $_MODE $_UPDATED_BARF
	executeCommand $_MODE "mqsideploy $_BROKER -e $_EGRP -a $_UPDATED_BARF"

	log "I >>deployBarFileToBrokerWithEG"
}

getUserInput()
{
	_PROMPT=$1
	_PASSWORD=""

	until [ ! -z "$_PASSWORD" ];
	do
		read -p "$_PROMPT" _PASSWORD
	done
	echo  "$_PASSWORD"
}
