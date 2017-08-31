#!/bin/ksh
# Shared Functions and Variables.
# Bhavesh Patel 8/20/98
# Modification History
# 08/30/00	SGarg	Added ARCH_COMP_DIR variable and functionality 
#                       in comp_arch_logs
#			function to move the compressed logs to compress 
#                       directory
# 08/30/00	SGarg	Removed Online redo log backup from cold backup
# 08/30/00	SGarg	Added functionality to back up Parameter file 
# 08/31/00	SGarg	Added post_bkup_arch_move function to move back 
#                       arch logs to ARCH_DIR 
#----------------------------------------
# Initialize the Global Variables.
#----------------------------------------
#set -x
YMD=$(date +'%Y%m%d')
HM=$(date +'%H%M')
YMD_HM=$(date +'%Y%m%d_%H%M')
RET_PD=7
OCDBA="db_eng_alert@chemdex.com"   # On call DBA.
SOCDBA="db_eng_alert@chemdex.com"   # Secondary On call DBA.
PAGEOCDBA="page-dbeng1@ventro.com" # Page the app. person.
REPLYTO="bpatel@chemdex.com"
#
ALL_ARGS="$@"
ARG_CNT=$#
THIS_PGM=$(basename $0)
THIS_RUN="${THIS_PGM} $@"
THIS_MAC=`hostname`
#
LOGDIR=$HOME/admin/${ORA_SID}/log
CTLDIR=$HOME/admin/${ORA_SID}/ctl
BINDIR=$HOME/dba/bin
TMPDIR="/tmp/$$"; export TMPDIR; mkdir ${TMPDIR}
JOBLOG=${LOGDIR}/${THIS_PGM}_${ORA_SID}_${YMD_HM}.joblog
#
STDERRLOG=${LOGDIR}/${THIS_PGM}_${ORA_SID}_errlog
TRCLOG=${LOGDIR}/${THIS_PGM}_${ORA_SID}_${YMD_HM}.trclog
#
EXPDEST=`cat $CTLDIR/exp_dir.dat`
PSWDFILE=${CTLDIR}/passwd.dat
EXPPIPE=${TMPDIR}/${THIS_PGM}_${ORA_SID}_exp_${OPT}_$$.pipe
EXPLOG=${LOGDIR}/${THIS_PGM}_${ORA_SID}_${OPT}_${YMD_HM}.log
SQLOUT=${TMPDIR}/sql_$$.out
MAILMSG=${TMPDIR}/mail.msg
#
NOTIFY_COUNT="${LOGDIR}/${ORA_SID}_${THIS_PGM}_err_count.txt"
STOP_PAGE_NOTIFICATION=${CTLDIR}/stop_notify.txt
#
ARCH_DIR=`cat ${CTLDIR}/arch_dir.dat`
ARCH_COMP_DIR=${ARCH_DIR}/compress
FTPOUT=${TMPDIR}/${THIS_PGM}_${ORA_SID}_ftp.log
STBY_INFO_FILE=${CTLDIR}/stby_info.dat
#
BKUP_DIR_LIST=${CTLDIR}/bkup_dir.dat
TAPE_NAME=$(cat ${CTLDIR}/tape_name.dat)
BKUP_DIR=$(cat ${BKUP_DIR_LIST} | grep ':Y' | cut -f1 -d':')
export BKUP_DIR
#
export PATH=$PATH:/usr/local/bin
#----------------------------------------
exit_on_error()
#----------------------------------------
{
PRVE_FUNC=${CURR_FUNC}
PROB_FUNC=${CURR_FUNC}
CURR_FUNC="exit_on_error"

echo ".....executing $CURR_FUNC" >> $JOBLOG

# need to clean the log.
sed -e s/system\\/.*$/system\\/xxxxx/ ${JOBLOG} >> \
	${TMPDIR}/`basename ${JOBLOG}`
mv ${TMPDIR}/`basename ${JOBLOG}` ${JOBLOG}
#
build_msg
exit -1
}

#----------------------------------------
exit_on_warning()
#----------------------------------------
{
PRVE_FUNC=$CURR_FUNC
CURR_FUNC="exit_on_warning"

echo ".....executing $CURR_FUNC" >> $JOBLOG

build_msg

exit -2
}

#---------------------------------------------------
build_msg()
#---------------------------------------------------
#
{
#
PRVE_FUNC=$CURR_FUNC
CURR_FUNC="build_msg"

echo ".....executing $CURR_FUNC" >> $JOBLOG

MSG_PGM=$(echo ${THIS_PGM} | awk -F"." '{ print $1 }' \
           | awk -F"_" '{ print $1 "_" $2 }')
MSG_DT=$(date +"%D")
MSG_TM=$(date +"%T")
FROM_SERVER=$(uname -n)
MSG_ARG=${ALL_ARGS:-n/a}
STATUS_REC=${STATUS_REC:-n/a}
MSG1=${MSG1:-n/a}
MSG2=${MSG2:-n/a}
SQL_RC=${SQL_RC:-0}
REC_ACTION=${REC_ACTION:-n/a}
cat >${MAILMSG} <<-EMSG
==============================================================================
Mail Date               = ${MSG_DT}
Mail Time               = ${MSG_TM}
Server                  = ${FROM_SERVER}
Oracle SID              = ${ORA_SID}
Script                  = ${THIS_PGM}
Arguments               = ${MSG_ARG}
Job Timestamp           = ${YMD_HM}
Job Log                 = ${JOBLOG}
Error Log               = ${STDERRLOG}
Trace Log               = ${TRCLOG}
Problem Function        = ${PROB_FUNC}
Previous Function       = ${PREV_FUNC}
Current Function        = ${CURR_FUNC}
Status Record           = ${STATUS_REC}
Severity Level          = ${SEV_LVL}
Message 1               = ${MSG1}
Message 2               = ${MSG2}
SQL*Plus Return Code    = ${SQL_RC}
Recommended Action      = ${REC_ACTION}
==============================================================================
EMSG
#

# Notify DBA
notify_dba "${ORA_SID}:${FROM_SERVER}:${THIS_PGM}" 
#
cat ${MAILMSG} >> ${JOBLOG}
}

#---------------------------------------
# Setup the Oracle Environment.
#---------------------------------------
oracle_env()
{
#
PRVE_FUNC=$CURR_FUNC
CURR_FUNC="oracle_env"

echo ".....executing $CURR_FUNC" >> $JOBLOG

if [ -f /var/opt/oracle/oratab ]
then
	ORATAB=/var/opt/oracle/oratab
else
	ORATAB=/etc/oratab
fi

ORATAB_SID=$(grep "^${ORA_SID}:" ${ORATAB}|awk -F: '{ print $1}')
ORATAB_SID=${ORATAB_SID:-NULL}

if [[ ${ORATAB_SID} != ${ORA_SID} ]]
then
        MSG1="Bad SID ${ORA_SID} specified"
        MSG2="Checking ${ORATAB}"
        REC_ACTION="Check spelling of SID"
        exit_on_error
fi

# Set up the Oracle Environemt.
ORACLE_SID=${ORA_SID}
ORAENV_ASK=NO
. oraenv

if [[ $? -ne 0 ]]
then
        MSG1="Bad return code from oraenv"
        MSG2=
        REC_ACTION="Check PATH and ORACLE_HOME for $(logname)"
        exit_on_error
fi

#
}

#---------------------------------
# Check the database availibility.
#---------------------------------

check_db_up()
{
#
PRVE_FUNC=$CURR_FUNC
CURR_FUNC="check_db_up"

echo ".....executing $CURR_FUNC" >> $JOBLOG

BGP_CNT=$(/usr/bin/ps -ef|grep "${ORA_SID}$"|grep -v grep|wc -l)

if [[ ${BGP_CNT} -lt 4 ]]
then
        MSG1="Database not available"
        MSG2=
        REC_ACTION="Check database health"
        exit_on_error
fi
}

#------------------------------------
# Get the System Password
#------------------------------------
get_sys_pswd()
{
#

PRVE_FUNC=$CURR_FUNC
CURR_FUNC="get_sys_pswd"

echo ".....executing $CURR_FUNC" >> $JOBLOG

if [ ! -s ${PSWDFILE} ]
then
        MSG1="Password file ${PSWDFILE} not found"
        MSG2=
        REC_ACTION="Check password file"
        exit_on_error
fi

ORAID=system
ORAPSWD=$(grep ":${ORA_SID}:" ${PSWDFILE}|grep "${ORAID}:" \
                |awk -F":" '{ print $4}')

if [[ -z ${ORAPSWD} ]]
then
        MSG1="Password file ${PSWDFILE} does not contain password for ${ORAID}"
        MSG2=
        REC_ACTION="Check password file"
        exit_on_error
fi
export ORAID ORAPSWD
}


#------------------------------------
# Get the Password
#------------------------------------
get_pswd()
{
#

PRVE_FUNC=$CURR_FUNC
CURR_FUNC="get_pswd"

echo ".....executing $CURR_FUNC" >> $JOBLOG

if [ ! -s ${PSWDFILE} ]
then
        MSG1="Password file ${PSWDFILE} not found"
        MSG2=
        REC_ACTION="Check password file"
        exit_on_error
fi

# Get the username as part of first argument.
ORAID=$1

ORAPSWD=$(grep -i ":${ORA_SID}:${ORAID}:" ${PSWDFILE}|awk -F":" '{ print $4}')

if [[ -z ${ORAPSWD} ]]
then
        MSG1="Password file ${PSWDFILE} does not contain password for ${ORAID}"
        MSG2=
        REC_ACTION="Check password file"
        exit_on_error
fi
export ORAID ORAPSWD
}

#-----------------------------------
# Select a parameter file.
#-----------------------------------
cr_parfile()
{
#
PRVE_FUNC=$CURR_FUNC
CURR_FUNC="cr_parfile"

echo ".....executing $CURR_FUNC" >> $JOBLOG

#
if [ $OPT != "USPARFILE" ]
then
	PARFILE=${BINDIR}/exp.par
fi
#
if [ ! -f ${PARFILE} ]
then
        MSG1="Parameter file $PARFILE not found"
        MSG2=
        REC_ACTION="Need to provide a parameter file"
        echo "....ERROR:  Parameter file not found"
        exit_on_error
fi

# Create the file.
TMPPARFILE=${TMPDIR}/.exp.par.$$
cat ${PARFILE} > ${TMPPARFILE}
echo "USERID=${ORAID}/${ORAPSWD}" >> ${TMPPARFILE}
echo "LOG=${EXPLOG}" >> ${TMPPARFILE}

if [ $OPT = "FULL" ]
then
        echo "FULL=Y" >> ${TMPPARFILE}
        echo "ROWS=Y" >> ${TMPPARFILE}
elif [ $OPT = "OWNER" ]
then
        echo "OWNER=${UNAME}" >> ${TMPPARFILE}
        echo "ROWS=Y" >> ${TMPPARFILE}
elif [ $OPT = "NOROWS" ]
then
        echo "FULL=Y" >> ${TMPPARFILE}
        echo "ROWS=N" >> ${TMPPARFILE}
fi
#
}


#------------------------------------
# Create the export pipe.
#------------------------------------
cr_exp_pipe()
{

PRVE_FUNC=$CURR_FUNC
CURR_FUNC="cr_exp_pipe"

echo ".....executing $CURR_FUNC" >> $JOBLOG

if [ ! -p ${EXPPIPE} ]
then
        mkfifo ${EXPPIPE} || {
        MSG1="Bad return code from mkfifo"
        MSG2="Setting up pipe"
        REC_ACTION="Check server health"
        exit_on_error
        }
fi

EXPDIR=${EXPDEST}
EXPFILE=${EXPDIR}/${ORA_SID}_exp_${OPT}_${YMD_HM}.dmp.Z
compress -c < ${EXPPIPE} |split -b 1800m - ${EXPFILE} &
#cat ${EXPPIPE} | compress > ${EXPFILE} &
echo "....export pipe:${EXPPIPE}">>${JOBLOG}
echo "....export file:${EXPFILE}">>${JOBLOG}

#Update the Par file.
echo "FILE=${EXPPIPE}" >> ${TMPPARFILE}

}

#------------------------------------
# Export the data.
#------------------------------------
exp_db()
{

PREV_FUNC=$CURR_FUNC
CURR_FUNC="exp_db"

echo ".....executing $CURR_FUNC"

echo "....Parameter file is:" >> ${JOBLOG}

if [ ${OPT} = "USPARFILE" ]
then
        cat ${PARFILE} >> ${JOBLOG}
	exp parfile=${PARFILE} >>${JOBLOG} 2>&1
else
        cat ${TMPPARFILE} >> ${JOBLOG}
	exp parfile=${TMPPARFILE} >>${JOBLOG} 2>&1
fi


if [ $? -ne 0 ]
then
        MSG1="Bad return code from export"
        MSG2="n/a"
        REC_ACTION="Check joblog"
        exit_on_error
fi

if [ -s ${EXPLOG} ]
then
        EXP_ERR_CNT=$(egrep -c '^EXP-' ${EXPLOG})
        if [ ${EXP_ERR_CNT} -gt 0 ]
        then
                MSG1="Job aborted with warnings"
                MSG2="n/a"
                REC_ACTION="Check joblog"
                exit_on_warning
        fi
fi

rm -f ${EXPPIPE}
rm -f ${TMPPARFILE}
echo >>${JOBLOG}

}


#------------------------------------
# Clean the log files etc.
#------------------------------------
clean_up()
{
PREV_FUNC=$CURR_FUNC
CURR_FUNC="clean_up"

echo ".....executing $CURR_FUNC"

# need to clean the log.
sed -e s/system\\/.*$/system\\/xxxxx/ ${JOBLOG}>> ${TMPDIR}/`basename ${JOBLOG}`
mv ${TMPDIR}/`basename ${JOBLOG}` ${JOBLOG}
#
# Everything was successful, as we reached here.  Create a Success file.
# Remove the notify count, if everything was successful.
# rm ${TMPDIR}/${ORA_SID}_*_count.txt
rm -rf ${TMPDIR}
}


#------------------------------------------
# Purge the old export files.
#------------------------------------------
purge_old_exp()
{
PREV_FUNC=$CURR_FUNC
CURR_FUNC="purge_old_exp"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Clear the old export files.
find ${EXPDEST} -mtime +${RET_PD} -name "${ORA_SID}_exp_${OPT}*.dmp.Z*" \
            -type f -exec rm -f {} \;

# Clear the old log files.
find ${LOGDIR} -mtime +${RET_PD} -name "exp_db.ksh_${ORA_SID}_*log" -type f \
            -exec rm -f {} \;
}


#-----------------------------------------
#  Notify DBA
#-----------------------------------------
notify_dba()
{
PREV_FUNC=$CURR_FUNC
CURR_FUNC="notify_dba"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

SUB=$1


# Send the mail.
if [ -f ${NOTIFY_COUNT} ]
then
	let cnt=`cat ${NOTIFY_COUNT}`+1
	echo "$cnt" > ${NOTIFY_COUNT}

	if [[ ${cnt} -eq 12 ]]
	then
		# It's 60 minutes now.  We need to clear the old count file.
		# So, DBA will start getting pages again !!
		rm ${NOTIFY_COUNT}
	fi
else
        cnt=1
	echo "$cnt" > ${NOTIFY_COUNT}
fi
#

if [ -f ${STOP_PAGE_NOTIFICATION} ]
then
	# No notification need to be sent.
	:
else
	if [[ `cat ${NOTIFY_COUNT}` -lt 3 ]]
	then
		# Mail.
		cat ${MAILMSG} | mailx -s ${SUB} -r ${REPLYTO} ${OCDBA}
		# Page.
		echo "Message:${MSG1}-${MSG2}-Look into ${JOBLOG}" \
			| mailx -s ${SUB} -r ${REPLYTO} ${PAGEOCDBA}
	elif [[ `cat ${NOTIFY_COUNT}` -lt 5 ]]
        then
		cat ${MAILMSG}| mailx -s Secondary${SUB} -r ${REPLYTO} ${SOCDBA}
		echo "Message:${MSG1}-${MSG2}-Look into ${JOBLOG}" \
			| mailx -s ${SUB} -r ${REPLYTO} ${PAGEOCDBA}
	fi
fi

#
}


#--------------------------------------
# Check out put status for SQL stmt.
#--------------------------------------
check_sql_rc()
{
#
# Don't populate the PREV_FUNC and CURR_FUNC.  So that, we get the correct
# function names for errors.  Chances of having error in this function is
# almost nil.
#PREV_FUNC=$CURR_FUNC
#CURR_FUNC="check_sql_rc"

# don't change the following check_sql_rc with CURR_FUNC variable.
echo ".....executing check_sql_rc" >> ${JOBLOG}
#
ERR_CNT=$(egrep -c '(ORA-|unable to)' ${SQLOUT})

echo $SQL_RC $ERR_CNT
if [[ ${SQL_RC} -ne 0 || ${ERR_CNT} -gt 0 ]]
then
        echo "SQL_RC=${SQL_RC} ; ERR_CNT=${ERR_CNT}">>${JOBLOG}
        echo "\n----- start of SQLOUT -----">>${JOBLOG}
        cat ${SQLOUT}>>${JOBLOG}
        echo "----- end of SQLOUT -----\n">>${JOBLOG}
        MSG1="Bad return code from sqlplus"
        MSG2=
        if [[ ${ERR_CNT} -gt 0 ]]
        then
                REC_ACTION="Check database health or table/view accessed"
                exit_on_error
        else
                REC_ACTION="Check joblog for sqlplus output"
        fi
#else
#	echo "Delete the sqlout file"
#	rm -f ${SQLOUT}
fi

}


#-------------------------------------------------------
# Need to compress all the logs except the current one.
#-------------------------------------------------------
comp_arch_logs()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="comp_arch_logs"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

ls -tr ${ARCH_DIR}/*[!Z] > ${TMPDIR}/tmp_$$.txt 
# Get the count minus one.  That way, we can avoid the latest archive
# file, which may the current archiving file.
ARCHCNT=`wc -l ${TMPDIR}/tmp_$$.txt | awk '{print $1-1}'`

if [[ ${ARCHCNT} -lt 2 ]]
then
	echo "Less then 1 files to be archived." >> ${JOBLOG}
	echo "Skipping the compress this time." >> ${JOBLOG}
else
	# Get read of the most latest file.  That may be the one, which
	# is the current archived log file.
        head -${ARCHCNT} ${TMPDIR}/tmp_$$.txt > ${TMPDIR}/tmp_$$_1.txt
	echo "The archived file list" >> ${JOBLOG}
	cat ${TMPDIR}/tmp_$$_1.txt >> ${JOBLOG}
	echo "--------------------------------" >> ${JOBLOG}

	for file in `cat ${TMPDIR}/tmp_$$_1.txt`
	do
		compress ${file}
                if [[ $? -ne 0 ]]
		then
			MSG1="Could not compress file ${file}"
			REC_ACTION="Check the space in ${ARCH_DIR} directory"
			exit_on_error
		fi
	
		# Wait till the job is completed.
		wait
# following lines commeneted out by SGarg on 8/31 because not yet ready to 
# put these changes in production
# These lines will move the compressed files to compress directory from 
# where legato will pick these up
#               if  [ ! -d ${ARCH_COMP_DIR} ]
#		then
#			uncompress ${file}
#			MSG1="${ARCH_COMP_DIR} does not exist"
#			REC_ACTION="Create ${ARCH_COMP_DIR} directory"
#			exit_on_error
#		fi
#		mv ${file}.Z ${ARCH_COMP_DIR}/.
	done
fi

}

#-------------------------------------------------------
# Need to move backed up logs to ARCH_DIR 
#-------------------------------------------------------
post_bkup_arch_move()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="post_bkup_arch_move"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

mv $ARCH_COMP_DIR/*.Z $ARCH_DIR/.
}

#---------------------------------------------------
# Get the latest sequence number for archived redo log.
#---------------------------------------------------
#
get_latest_arch_seq()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="get_latest_arch_seq"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# First, switch the logfile, so the cureent archive is archived.
switch_log

# Get the latest sequence number for archived log file.

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select ltrim(max(sequence#),' ') from v\$log where archived='YES'
;
exit
SQL

SQL_RC=$?
check_sql_rc

cp ${SQLOUT} ${CTLDIR}/${ORA_SID}_latest.arc
}

#---------------------------------------------------
# Compress the logs for primary and ftp it to standby.
#---------------------------------------------------
comp_primary_logs()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="comp_primary_logs"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

#if [[ ! -f ${CTLDIR}/${ORA_SID}_latest.arc ]]
#then
#	MSG1="Error in creating ${ORA_SID}_latest.arc file"
#	MSG2=
#	REC_ACTION=
#	exit_on_error
#fi

# All the non compressed files upto the latest arch number can be 
# FTPed to standby and can be compressed.
#
# Get the Position for LSN number.
SEQ_NO_LOC=`grep "PRIM_LOG_SEQ_POS:" ${STBY_INFO_FILE} | awk -F":" '{print $2}'`
#
# Get the Latest LSN number.
#LATEST_SEQ_NO=`head -n1 ${CTLDIR}/${ORA_SID}_latest.arc`

ls -tr ${ARCH_DIR}/*[!Z!m] > ${TMPDIR}/tmp_$$.txt
# Get the count less then one, to avoid the probably current arch redo.
CNT=`wc ${TMPDIR}/tmp_$$.txt | awk '{print $1-1}'`

# Get list of all files, except the latest one.
head -${CNT} ${TMPDIR}/tmp_$$.txt > ${TMPDIR}/tmp_$$_1.txt

# Process (i.e. ftp, compress, move) each file.
for file in `cat ${TMPDIR}/tmp_$$_1.txt`
do
	SEQNO=`basename ${file} | cut -c${SEQ_NO_LOC}`
        cksum ${file} > ${file}.prim.cksum
	echo "The cksum is "
	cat  ${file}.prim.cksum
        #
	get_stby_pswd
	echo "Now got the paswd"
	ftp_arch_to_stby ${file}
	echo "Now the ftp to stby"
	compress ${file}
        if [[ $? -ne 0 ]]
	then
		MSG1="Could not compress file ${file}"
		MSG2
		REC_ACTION="Check the space in ${ARCH_DIR} directory"
		exit_on_error
	fi
	
	# Move the archive and cksum files to bkup directory.
	# This will be backedup in the night and will be moved/deleted.
        mv ${file}.Z ${BKUP_DIR}
        mv ${file}.prim.cksum ${BKUP_DIR}

	if [[ $? -ne 0 ]]
	then
		MSG1="Error in moving files:"
		MSG2="From ${ARCH_DIR} to ${BKUP_DIR}"
		REC_ACTION="Check the free space"
		exit_on_error
	fi
done
}


#---------------------------------------------------
# Switch the log files.
#---------------------------------------------------

switch_log()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="switch_log"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL>${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
alter system switch logfile
;
exit
SQL

SQL_RC=$?
check_sql_rc

# Wait for 5 seconds to make sure that, archive starts for the current 
# online redo log.
sleep 5
#
}


#----------------------------------------------------
# Move the compressed archives to a backup area.
#----------------------------------------------------
move_comp_arch()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="move_comp_arch"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

if [ -f ${ARCH_DIR}/*.Z ]
then
	mv ${ARCH_DIR}/*.Z ${BKUP_DIR}
fi

if [[ $? -ne 0 ]]
then
	MSG1="Error in moving files: exit code: $?"
	MSG2="From ${ARCH_DIR} to ${BKUP_DIR}"
	REC_ACTION="Check the free space"
	exit_on_error
fi

#
}


#------------------------------------------------------------
# Get the Standy user password.
#------------------------------------------------------------

get_stby_pswd()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="get_stby_pswd"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

STBYID=oracle

# Get the password for Unix id.
STBYPSWD=`grep "${STBYID}:" ${STBY_INFO_FILE} | awk -F":" '{print $4}'`

if [[ "X"${STBYPSWD} = "X" ]]
then
	MSG1="ERROR!! Password for Stand by database not found"
	MSG2=
	REC_ACTION="Check the password file "
	exit_on_error
fi

# Get the host id.
STBYHOST=`grep "${STBYID}:" ${STBY_INFO_FILE} | awk -F":" '{print $1}'`

if [[ "X"${STBYHOST} = "X" ]]
then
        MSG1="ERROR!! Stand by host name not found  "
        MSG2=
        REC_ACTION="Check the password file "
        exit_on_error
fi
#
}


#------------------------------------------------------
# Ftp the archived redo to standby machine.
#------------------------------------------------------
ftp_arch_to_stby()
{
#
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="ftp_arch_to_stby"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

fileToFtp=`basename $1`

STBY_FTP_LOG_DIR=`cat ${STBY_INFO_FILE} | grep "STBY_FTP_LOG_DIR:" \
   | awk -F":" '{print $2}'`
STBY_HOME_DIR=`cat ${STBY_INFO_FILE} | grep ${STBYID} | awk -F":" '{print $5}'`

echo stby dir is $STBY_FTP_LOG_DIR
echo stby home dir is $STBY_HOME_DIR
echo file to ftp is ${fileToFtp}

#echo stbyhost is $STBYHOST
#echo stbyid and passwd are $STBYID and $STBYPSWD

ftp -n -v  <<-EFTP >${FTPOUT} 2>&1 
	open ${STBYHOST}
	user ${STBYID} ${STBYPSWD}
	binary
        prompt
        cd ${STBY_FTP_LOG_DIR}
        lcd ${ARCH_DIR}
	put ${fileToFtp}
	put ${fileToFtp}.prim.cksum
	bye
EFTP
#
#cat ${FTPOUT} >> ${JOBLOG}

if [[ $? != 0 || $(egrep -c -i 'failed|incorrect|err|full|no such\
   |No space left|not a dir|timed out|not connected' ${FTPOUT} ) -gt 0  ]]
then
        MSG1="!ERROR! Problem with ftp to standby"
        MSG2=""
        REC_ACTION="Check the job log"
        #cat ${FTPOUT} >> ${JOBLOG}
        rm ${FTPOUT}
        exit_on_error
else
        echo "..ftp completed successfully" >>${JOBLOG}
fi

#Clean up.
rm ${FTPOUT}
}


#------------------------------------------------------------
# Check the cksum for the archive log files.
#------------------------------------------------------------
check_alogs_cksum()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="check_alogs_cksum"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Make the list of files, which has been transferred from primary to standby.
ls ${STBY_FTP_LOG_DIR}/*.prim.cksum > ${TMPDIR}/alogs_$$.lst

if [ -s ${TMPDIR}/alogs_$$.lst ]
then
	echo "It has the following files to apply" >> ${JOBLOG}
	cat ${TMPDIR}/alogs_$$.lst >> ${JOBLOG}
else
	echo "No files has been transferred"
	echo "Exist successfully."
	exit 0
fi


#for file in `cat ${STBY_FTP_LOG_DIR}/*[!m]`
for file in `cat ${TMPDIR}/alogs_$$.lst`
do
	LFILE=`basename ${file} | cut -d'.' -f1`
	#DIR=`dirname ${file}`

	cksum ${STBY_FTP_LOG_DIR}/${LFILE} > ${TMPDIR}/${LFILE}.stby.cksum
	cat ${TMPDIR}/${LFILE}.stby.cksum >> ${JOBLOG}
	# Get the file name.

	# Get the cksum info.
	PRIMFILECKSTR=`cat ${STBY_FTP_LOG_DIR}/${LFILE}.prim.cksum \
        | cut -f1 -d'/'`
	STBYFILECKSTR=`cat ${TMPDIR}/${LFILE}.stby.cksum | cut -f1 -d'/'`
	# Compare the cksum info.
	if [[ "${PRIMFILECKSTR}" != "${STBYFILECKSTR}" ]]
	then
        	MSG1="ERROR!! Cksum did not match"
        	MSG2="File is: ${TMPDIR}/${LFILE}"
        	REC_ACTION="Check the files"
		exit_on_error
	else
		# Everything is clear.  Remove the cksum.
		rm ${TMPDIR}/${LFILE}*.cksum
		rm ${STBY_FTP_LOG_DIR}/${LFILE}*.cksum
		mv ${STBY_FTP_LOG_DIR}/${LFILE} ${STBY_LOG_ARCHIVE_DEST}
		if [[ $? -ne 0 ]]
		then
			MSG1="Error in moving files:"
			MSG2="From ${TMPDIR}/${LFILE} to ${STBY_LOG_ARCHIVE_DEST}"
			REC_ACTION="Check the free space"
			exit_on_error
		fi
	fi
done
}


#-----------------------------------------------------------
# Apply the redo logs to standby database.
#-----------------------------------------------------------
app_stby_redo()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="app_stby_redo"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

#-----------------------------
# IMPORTANT:  DO NOT DELETE THE BLANK LINE BEFORE THE CANCEL COMMAND.
#             IT ACTS AS AN ENTER FOR APPLYING THE REDOS !!!
#-----------------------------

for file in `ls ${STBY_LOG_ARCHIVE_DEST}`
do
	svrmgrl <<-SQL > ${SQLOUT} 2>&1
	connect internal;
	recover standby database until cancel;

	cancel;
	exit;
SQL
	
	# Cat the out put to log file.
	cat ${SQLOUT} >> ${JOBLOG}

	# Check for the errors.
	grep "ORA-" ${SQLOUT} | egrep -v "ORA-00279|ORA-00289|ORA-00280|ORA-00278"
	if [ $? -eq 0 ]
	then
		MSG1="Error in applying redo logs"
		MSG2="May be file is ${file}"
		REC_ACTION=
		exit_on_error
	else
		echo ""
	fi
done
}


#-----------------------------------------------------------------
# Move the applied logs to backup directory.
#-----------------------------------------------------------------
stby_logs_to_bkup()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="stby_logs_to_bkup"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Move the files to bkup direcory.
mv ${STBY_LOG_ARCHIVE_DEST}/* ${STBY_BKUP_ARCH_DIR}
if [[ $? -ne 0 ]]
then
	MSG1="Error in moving files:"
	MSG2="From ${STBY_LOG_ARCHIVE_DEST} to ${STBY_BKUP_ARCH_DIR}"
	REC_ACTION="Check the free space"
	exit_on_error
fi
}


#-----------------------------------------------
#  Start the database
#-----------------------------------------------
start_db()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="start_db"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

svrmgrl <<-SQL > ${SQLOUT} 2>&1
connect internal;
startup;
exit;
SQL

# Cat the out put to log file.
cat ${SQLOUT} >> ${JOBLOG}

# Check for the errors.
grep "ORA-" ${SQLOUT} 
if [ $? -eq 0 ]
then
	MSG1="Error in starting the database "
	MSG2=
	REC_ACTION=
	exit_on_error
fi

}


#-----------------------------------------------
#  Stop the database
#-----------------------------------------------
stop_db()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="stop_db"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# First, backup the control trace file.
db_physical_info

svrmgrl <<-SQL > ${SQLOUT} 2>&1
connect internal;
shutdown immediate;
exit;
SQL

# Cat the out put to log file.
cat ${SQLOUT} >> ${JOBLOG}

# Check for the errors.
grep "ORA-" ${SQLOUT} 
if [ $? -eq 0 ]
then
	MSG1="Error in shutdown the database "
	MSG2=
	REC_ACTION=
	exit_on_error
fi

#
}


#-----------------------------------------------------
#  Back up the control file.
#-----------------------------------------------------
db_physical_info()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="db_physical_info"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# The SQL command control file needs to be backedup.
# First get the User Dump Destination.
sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select value from v\$parameter where name like 'user_dump_dest'
;
exit
SQL
#
SQL_RC=$?
check_sql_rc

# copy the output.
cp ${SQLOUT} ${TMPDIR}/tmp_$$.txt
#

UDUMP_DIR=`cat ${TMPDIR}/tmp_$$.txt`
#
# Find out the archive log mode.
archlog_mode

if [[ ${ARCHLOG} = "TRUE" ]]
then
	sqlplus -s <<-SQL >${SQLOUT} 2>&1
	${ORAID}/${ORAPSWD}
	whenever SQLERROR exit FAILURE
	whenever OSERROR  exit FAILURE
	rem Need to preserve the database structure.
	set heading on feed on timing off pagesize 60 echo on
	spool ${BKUP_DIR}/db_file_structure.lst;
	alter system archive log current;
	alter database backup controlfile to trace;
	select * from dba_data_files;
	select * from v\$logfile;
	select * from v\$log;
	select * from dba_tablespaces;
	spool off
	exit
SQL
else
	# Can not use the archive log current statement.
	sqlplus -s <<-SQL >${SQLOUT} 2>&1
	${ORAID}/${ORAPSWD}
	whenever SQLERROR exit FAILURE
	whenever OSERROR  exit FAILURE
	rem Need to preserve the database structure.
	set heading on feed on timing off pagesize 60 echo on
	spool ${BKUP_DIR}/db_file_structure.lst;
	rem alter system archive log current;
	alter database backup controlfile to trace;
	select * from dba_data_files;
	select * from v\$logfile;
	select * from v\$log;
	select * from dba_tablespaces;
	spool off
	exit
SQL
fi
#
# Check for the errors.
SQL_RC=$?
check_sql_rc
#
# Copy the control trace file to bkup dir.
TRACE_FILE=`ls -t ${UDUMP_DIR}/* | head -1`
mv ${TRACE_FILE} ${BKUP_DIR}/${ORA_SID}_control.sql
#
# copy the init.ora file.
cp ${ORACLE_HOME}/dbs/init${ORA_SID}.ora ${BKUP_DIR}
#
}


#-----------------------------------------------------
# Find the archivelog mode.
#-----------------------------------------------------
archlog_mode()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="archlog_mode"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading on feed on timing off pagesize 60 echo on
select log_mode from v\$database;
exit
SQL
#
# Check for the errors.
SQL_RC=$?
check_sql_rc

if [[ $(cat ${SQLOUT}) = "ARCHIVELOG" ]]
then
	ARCHLOG="TRUE"
else
	ARCHLOG="FALSE"
fi
export ARCHLOG;
}


#-----------------------------------------------------
#  List of Data file to backup.
#-----------------------------------------------------
data_file_list()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="data_file_list"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select file_name from dba_data_files
;
exit
SQL
#
SQL_RC=$?
check_sql_rc

# Copy the output. 
cp ${SQLOUT} ${TMPDIR}/tmp_$$.txt


# This files will be copies later on.
cp ${TMPDIR}/tmp_$$.txt ${CTLDIR}/${ORA_SID}_datafile.list

}


#-----------------------------------------------------
#  List of Data file to backup.
#-----------------------------------------------------
hot_bkup_ts_data_file_list()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="hot_bkup_ts_data_file_list"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select file_name from dba_data_files
where tablespace_name='${TS_NAME}'
;
exit
SQL
#
SQL_RC=$?
check_sql_rc

# Copy the output. 
cp ${SQLOUT} ${TMPDIR}/tmp_$$.txt

# This files will be copies later on.
cp ${TMPDIR}/tmp_$$.txt ${CTLDIR}/${ORA_SID}_${TS_NAME}_datafile.list

}


#-----------------------------------------------------
#  Backup the tablespace.
#-----------------------------------------------------
bkup_ts()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="bkup_ts"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Get the list of the file to be backed up.
# Copy the output. 
hot_bkup_ts_data_file_list

for file in $(cat ${CTLDIR}/${ORA_SID}_${TS_NAME}_datafile.list)
do
        bkup_file ${file}
done
# Wait till all the files are backed up.
wait
#
}

#-----------------------------------------------------
#  List of Data file to backup.
#-----------------------------------------------------
hot_bkup_ts_list()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="hot_bkup_ts_list"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select tablespace_name from dba_tablespaces
;
exit
SQL
#
SQL_RC=$?
check_sql_rc

# Copy the output. 
cp ${SQLOUT} ${TMPDIR}/tmp_$$.txt


# This files will be copies later on.
cp ${TMPDIR}/tmp_$$.txt ${CTLDIR}/${ORA_SID}_ts.list

}

#-----------------------------------------------------
# Online redo logs list.
#-----------------------------------------------------
online_redo_list()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="online_redo_list"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0
select member from v\$logfile
;
exit
SQL

SQL_RC=$?
check_sql_rc

# These files will be copies later on.
cp ${SQLOUT} ${CTLDIR}/${ORA_SID}_onlinelog.list

}

#-----------------------------------------------------
# control file list.
#-----------------------------------------------------
ctl_init_file_list()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="ctl_init_file_list"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL >${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0 linesize 200
select value from v\$parameter where name like 'control_files'
;
exit
SQL
#
SQL_RC=$?
check_sql_rc
#
# Copy output.
cp ${SQLOUT} ${TMPDIR}/tmp_$$.txt

# Copy only the first 3 control files.
CF1=`cat ${TMPDIR}/tmp_$$.txt | cut -f1 -d','`
CF2=`cat ${TMPDIR}/tmp_$$.txt | cut -f2 -d','`
CF3=`cat ${TMPDIR}/tmp_$$.txt | cut -f3 -d','`

if [ -f $CF1 ]
then
	echo $CF1 > ${CTLDIR}/${ORA_SID}_control_init_file.list
fi

if [ -f $CF2 ]
then
	echo $CF2 >> ${CTLDIR}/${ORA_SID}_control_init_file.list
fi

if [ -f $CF3 ]
then
	echo $CF3 >> ${CTLDIR}/${ORA_SID}_control_init_file.list
fi
# Get the init.ora file.
echo $ORACLE_HOME/dbs/init${ORA_SID}.ora >> ${ORA_SID}_control_init_file.list
#
}

#-----------------------------------------------------
# Archive log file list.
#-----------------------------------------------------
#--- Bhavesh Patel 11/11/99
#--- No more creating the archive log list.  Archive list
#--- will be deleted separately.
#---arch_log_list()
#---{
#---PREV_FUNC=${CURR_FUNC}
#---CURR_FUNC="arch_log_list"
#---
#---echo ".....executing $CURR_FUNC" >> ${JOBLOG}
#---
#---# Mainly for the hot backup, we need to get the current redo to be 
#---# backed up with the tablespaces, which were backedup in hot backup mode.
#---
#---if [ ${BKUP_TYPE} = "HOT" ]
#---then
#---	# First switch log file for couple of times.  Once should be sufficient.
#---	# changed.  Switch log file only once.  Unix does not stroe
#---	# the time based on seconds.  So, consecutive switch log
#---	# does not help.
#---	sqlplus -s <<-SQL>${SQLOUT} 2>&1
#---	${ORAID}/${ORAPSWD}
#---	whenever SQLERROR exit FAILURE
#---	whenever OSERROR  exit FAILURE
#---	set heading off echo off timing off feed off pages 0 lines 20
#---	alter system switch logfile
#---	;
#---	exit
#---SQL
#---	# Occasionaly, you can get the following, which is harmless.
#---	# ORA-00271: there are no logs that need archiving
#---	# so remove them from the SQLOUT file.
#---	# cat ${SQLOUT} | grep -v "ORA-00271" > /tmp/t1_$$
#---	# mv /tmp/t1_$$ ${SQLOUT}
#---	#
#---	SQL_RC=$?
#---	check_sql_rc
#---	#
#---	# Sleep some time to finish archiving.
#---	sleep 120
#---#
#---fi
#---# archived redo log file.
#---ls -tr ${ARCH_DIR}/* > ${TMPDIR}/tmp_$$.txt
#---# Get the count minus one.  That way, we can avoid the latest archive
#---# file, which may the current archiving file.
#---ARCHCNT=`wc -l ${TMPDIR}/tmp_$$.txt | awk '{print $1-1}'`
#---
#---if [ ${ARCHCNT} -gt 1 ]
#---then
#---	head -${ARCHCNT} ${TMPDIR}/tmp_$$.txt > ${TMPDIR}/tmp_$$_1.txt
#---	cp ${TMPDIR}/tmp_$$_1.txt ${CTLDIR}/${ORA_SID}_archlog.list
#---else
#---	# Create a blank file.
#---	> ${CTLDIR}/${ORA_SID}_archlog.list
#---fi
#---#
#---}

#-----------------------------------------------------
# Update/change the backup dir location. Clean the files form the
# new bkup dir.
#-----------------------------------------------------
get_new_bkupdir()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="get_new_bkupdir"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# We are goint to create a file, which will list all the backup
# directories.  Depending upon the flag, we will rotate the directory.
# Number of lines in the bkup file.
LINE_CNT=$(wc -l ${BKUP_DIR_LIST} | awk '{print $1}')
FLAG_LINE=$(grep -n 'Y' ${BKUP_DIR_LIST} | cut -f1 -d':')
# Increment one for next line.
let FLAG_LINE=${FLAG_LINE}+1

if [[ ${FLAG_LINE} -gt ${LINE_CNT} ]]
then
	FLAG_LINE=1
fi
#
# remove the old flag.
sed 's/Y//' ${BKUP_DIR_LIST} > ${TMPDIR}/bkup_dir.txt
# Add the new flag.
sed ${FLAG_LINE}s/$/Y/ ${TMPDIR}/bkup_dir.txt > ${TMPDIR}/bkup_dir.txt2
mv ${TMPDIR}/bkup_dir.txt2 ${BKUP_DIR_LIST}

# New backup dir.
BKUP_DIR=$(cat ${BKUP_DIR_LIST} | grep ':Y' | cut -f1 -d':')
# Clean the new backup dir.
rm ${BKUP_DIR}/*
#
}

#-----------------------------------------------------
# Create the cold backup script.
#-----------------------------------------------------
cr_cold_bkup_filelist()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="cr_cold_bkup_filelist"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Get the list of the data files
data_file_list

# Commented out online redo log backups on 8/30/00  by SGarg
# Decided against backing up online redo logs
# On line redo logs
# online_redo_list

# Control file 
ctl_init_file_list

# Archived file 
#--- Bhavesh Patel 11/11/99
#--- No more creating the archive list, as they are now indepent of
#--- backup.
#---arch_log_list
}


#-----------------------------------------------------
# Create the hot backup script.
#-----------------------------------------------------
hot_bkup_nondata_files()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="hot_bkup_notdata_files"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Commented out online redo log backups on 8/30/00  by SGarg
# Decided against backing up online redo logs
# On line redo logs
# online_redo_list

# Control file 
ctl_init_file_list

# Archived file 
#--- No more archive redo.
#--- Bhavesh Patel 11/11/99
#--- arch_log_list

# We copy the following four file groups.
#	2.  Online Logs
#	4.  Control Files.
# Each group will be executed sequentially.  But, the files in each
# group will be copied simulatenously.
#--- Remove following.  Bhavesh Patel 11/11/99
#--- ${CTLDIR}/${ORA_SID}_archlog.list \
# Removed following on 8/30/00 by SGarg
#${CTLDIR}/${ORA_SID}_onlinelog.list \

for file_list in \
${CTLDIR}/${ORA_SID}_control_init_file.list 
do
	for file in $(cat ${file_list})
	do
		bkup_file ${file}
	done
	# Wait till all the files are backed up.
	wait
done

# Now remove the archive logs.
#--- Commented out on 11/5/99.  Due to change in the script.
#--- No longer delete as part of backup.  Will be deleted as part
#--- of clean up script.
#---if [ -s ${CTLDIR}/${ORA_SID}_archlog.list ]
#---then
#---	rm $(cat ${CTLDIR}/${ORA_SID}_archlog.list)
#---fi
#
}

#-------------------------------------------------
# Perform the cold backup.
#-------------------------------------------------
cold_bkup()
{
PREV_FUNC=${THIS_PGM}
CURR_FUNC="cold_bkup"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# We copy the following four file groups.
#	1.  Date Files
#	2.  Online Logs
#	3.  Archived Logs
#	4.  Control Files.
# Each group will be executed sequentially.  But, the files in each
# group will be copied simulatenously.

#--- Removed the following.
#--- Bhavesh Patel 11/11/99
#--- ${CTLDIR}/${ORA_SID}_archlog.list \
# Removed following on 8/30/00 by SGarg 
#${CTLDIR}/${ORA_SID}_onlinelog.list \
for file_list in \
${CTLDIR}/${ORA_SID}_datafile.list \
${CTLDIR}/${ORA_SID}_control_init_file.list 
do
	for file in $(cat ${file_list})
	do
		bkup_file ${file}
	done
	# Wait till all the files are backed up.
	wait
done

# Now remove the archive logs.
if [ -s ${CTLDIR}/${ORA_SID}_archlog.list ]
then
	rm $(cat ${CTLDIR}/${ORA_SID}_archlog.list)
fi
#
}


#-------------------------------------------------
# Perform the hot backup.
#-------------------------------------------------
hot_bkup()
{
PREV_FUNC=${THIS_PGM}
CURR_FUNC="hot_bkup"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# First, backup the control trace file.
db_physical_info

# Backup each tablespace, one at a time.
# Create the tablespace list.
hot_bkup_ts_list

# Do the backup for each tablespace.
cat ${CTLDIR}/${ORA_SID}_ts.list | while read TS_NAME
do
	sqlplus -s <<-SQL>${SQLOUT} 2>&1
	${ORAID}/${ORAPSWD}
	whenever SQLERROR exit FAILURE
	whenever OSERROR  exit FAILURE
	set heading off echo off timing off feed off pages 0 lines 20
	alter tablespace ${TS_NAME} begin backup
	;
	exit
	SQL
	#
	SQL_RC=$?
	check_sql_rc
	#
	# copy the data files, which belongs to this tablespace.
	bkup_ts
	#
	# Tablespace backup is completed.
	sqlplus -s <<-SQL>${SQLOUT} 2>&1
	${ORAID}/${ORAPSWD}
	whenever SQLERROR exit FAILURE
	whenever OSERROR  exit FAILURE
	set heading off echo off timing off feed off pages 0 lines 20
	alter tablespace ${TS_NAME} end backup
	;
	exit
	SQL
	#
	SQL_RC=$?
	check_sql_rc
	#
done

# Backup the rest of the files.
hot_bkup_nondata_files
#
}

#-------------------------------------------------
# Begin the process.
#-------------------------------------------------
begin_process()
{
PREV_FUNC=${THIS_PGM}
CURR_FUNC="begin_process"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Mainly to protect duplicate process running at the same time.
# Also, to prevent the same process run again, even if the process had
# died earlier due to an error.

# Check for a lock file.  If the file exist, exist with an error message
# otherwise create the lock file.
if [ -f ${CTLDIR}/${ORA_SID}_${THIS_PGM}.running ]
then
	MSG1="The program is already running"
	MSG2="File ${CTLDIR}/${ORA_SID}_${THIS_PGM}.running exists"
	REC_ACTION=
	exit_on_error
elif [ -f ${CTLDIR}/${ORA_SID}_${THIS_PGM}.stop ]
then
	MSG1="This program is not supposed to run."
	MSG2="File ${CTLDIR}/${ORA_SID}_${THIS_PGM}.stop exists"
	REC_ACTION=
	exit_on_error
else
	# File does not exist.  Create one.
	> ${CTLDIR}/${ORA_SID}_${THIS_PGM}.running
fi
echo hi there ${THIS_PGM}
#
# Timings.
echo "Process Begin Time: " $(date) >> ${JOBLOG}
}

#-------------------------------------------------
# End the process.
#-------------------------------------------------
end_process()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="end_process"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Mainly to protect duplicate process running at the same time.
# Also, to prevent the same process run again, even if the process had
# died earlier due to an error.

# 
# Delete the file.  Pgm must have run successfully to come to this stage.
rm ${CTLDIR}/${ORA_SID}_${THIS_PGM}.running
# Remove the Notify count.
rm ${NOTIFY_COUNT}

# Remove the tmp directory.
rm -rf ${TMPDIR}
#
# Timings.
echo "Process End Time: " $(date) >> ${JOBLOG}
#
# Exit successfully.
exit 0
}

#------------------------------------------------------------
#  Backup the file.
#------------------------------------------------------------
bkup_file()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="bkup_file"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Create the pipe.
FILE=$1
BFILE=$(basename ${FILE})
PIPE_FILE=${TMPDIR}/${BFILE}.pipe

#  check if file already exist.  that means, it's duplicate.
#
if [ -f ${BKUP_DIR}/${BFILE}* ]
then
	MSG1="File ${file} is duplicate"
        MSG2=""
        REC_ACTION="Rename the file in the database"
        exit_on_error
fi
#
#
# Create the pipe.
if [[ ! -p ${PIPE_FILE} ]]
then
        mkfifo ${PIPE_FILE} || {
        MSG1="Can not create ${PIPE_FILE} using mkfifo"
        MSG2=
        REC_ACTION=
        exit_on_error
        }
fi
#
# Do the actual backup using dd.
(( DD_BS = ${DB_BS} *  20 ))
#
# Run the compress in the background.
if [ ${COMPRESS} = "COMPRESS" ]
then
        (
        compress -c < ${PIPE_FILE} > ${BKUP_DIR}/${BFILE}.Z || {
                MSG1="Error in compress the ${PIPE_FILE} file"
                MSG2=
                REC_ACTION=
                exit_on_error
                }
        ) &
        #
        (
        dd if=${FILE} of=${PIPE_FILE} bs=${DD_BS} >> ${JOBLOG} 2>&1 || {
                MSG1="Error in dd the ${FILE}"
                MSG2=
                REC_ACTION=
                exit_on_error
                }
        ) &
else
        (
        dd if=${FILE} of=${BKUP_DIR}/${BFILE} bs=${DD_BS} >> ${JOBLOG} 2>&1 || {
                MSG1="Error in dd the ${FILE}"
                MSG2=
                REC_ACTION=
                exit_on_error
                }
        ) &
fi
echo "....${FILE} backup submitted as PID $!">>${JOBLOG}
#
}


#--------------------------------------------------------------
# Get the datbase block size.
#--------------------------------------------------------------
get_db_bs()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="get_db_bs"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

sqlplus -s <<-SQL>${SQLOUT} 2>&1
${ORAID}/${ORAPSWD}
whenever SQLERROR exit FAILURE
whenever OSERROR  exit FAILURE
set heading off echo off timing off feed off pages 0 lines 20
select value
from v\$parameter
where name = 'db_block_size'
;
exit
SQL
#
SQL_RC=$?
check_sql_rc
#
DB_BS=$(cat ${SQLOUT})
echo "....database block size:${DB_BS}">>${JOBLOG}
#
}

#--------------------------------------------------------------
# Execute the tape backup.
#--------------------------------------------------------------
db_tape_bkup()
{
PREV_FUNC=${CURR_FUNC}
CURR_FUNC="db_tape_bkup"

echo ".....executing $CURR_FUNC" >> ${JOBLOG}

# Back up all the datafiles on tape.
/usr/bin/save -g ${TAPE_NAME} $BKUP_DIR >> ${JOBLOG}

# Back up all archived redo logs.
/usr/bin/save -g ${TAPE_NAME} $ARCH_DIR >> ${JOBLOG}
#
}
