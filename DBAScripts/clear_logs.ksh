#!/bin/ksh
#-------------------------------------------------------------------
#
#	File:	clear_logs.ksh
#
#	Purpose: Clear the logs.
#
#	Author:	Bhavesh Patel
#
#	Date: 9/5/98
#
#-------------------------------------------------------------------
#
# Validate the args.
if [[ $# -ne 1 ]]
then
	echo "Usage: clear_logs.ksh <oracle-sid>"
	exit -1
fi

ORA_SID=$1
#
LOGS_FILE=$HOME/admin/${ORA_SID}/ctl/clear_logs.dat

for file in `cat ${LOGS_FILE} | grep -v '^#'`
do
	DIR=`echo ${file} | cut -f1 -d':'`
	RET_PERIOD=`echo ${file} | cut -f2 -d':'`
	find ${DIR} -mtime +${RET_PERIOD} -type f -exec rm -f {} \;
	#
	# If it's bdump directory, truncate the alert log file.
	echo ${file} | grep bdump
	STAT=$?
	if [[ ${STAT} -eq 0 ]]
	then
		tail -1000 ${DIR}/alert_${ORA_SID}.log > /tmp/alert_${ORA_SID}.log
		mv /tmp/alert_${ORA_SID}.log ${DIR}/alert_${ORA_SID}.log
	fi
done
