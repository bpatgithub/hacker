#!/usr/bin/ksh
set -x

#***************************************************************************
#
# Name:
#
# Purpose:
#
# Usage:
#
# History
#
#
#***************************************************************************

unalias cd
unalias rm
unalias cp
 
#----------
ORA_SID=$1
. ${HOME}/dba/bin/shrfuncs.ksh

#-----------
ret_stat=$(ps -ef | grep -v 'grep' | grep PMD_to_Collection_pims.ksh | wc -l | awk '{print $1}')

if [[ $ret_stat -gt 3 ]]
then
 	echo That means, the process is already running.
	exit 0
fi

begin_process

#-------
oracle_env


#Update bellow this line please.
PMD_TOP=$HOME/admin/pdb2
PMD_LOG=PMD_to_Collection_update

PMD_USERID=pims17
PMD_PASS=pickone
PMD_DBSTRING=pdb2
PMD_DBNAME=PMD

ROW_NUM=300

export PMD_TOP PMD_LOG ROW_NUM 
export PMD_USERID PMD_PASS PMD_DBSTRING PMD_DBNAME 

TNS_ADMIN=/var/opt/oracle; export TNS_ADMIN
PATH=$ORACLE_HOME/bin:/bin:/usr/bin:/etc; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib; export LD_LIBRARY_PATH 


SQL_RC=$?
#----put SQLOUT to JOBLOG.
cat $SQLOUT >> $JOBLOG

# move data from pmd_index to be published.
$ORACLE_HOME/bin/sqlplus -s $PMD_USERID/$PMD_PASS <<EOF_PMD_INDEX_TAG >> $SQLOUT 2>&1

SET SCAN OFF
set serveroutput on size 1000000
prompt will exuecute proc

EXECUTE PIMS_PMD.PMD_INDEX($ROW_NUM);

exit

EOF_PMD_INDEX_TAG

SQL_RC=$?
#----put SQLOUT to JOBLOG.
cat $SQLOUT >> $JOBLOG

check_sql_rc


echo "" >> $JOBLOG  2>&1
echo "" >> $JOBLOG  2>&1

#----------------
end_process
