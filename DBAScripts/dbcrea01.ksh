#!/bin/ksh
#
#  Script:  dbcrea01.ksh  (Created by build_SID.ksh)
#
#---------------------------------------------------
#    Prepare environment 
#---------------------------------------------------
YMD_HM=$(date +'%y%m%d_%H%M')

export PATH=/usr/local/bin:$PATH
export ORACLE_SID=##SID
export ORAENV_ASK=NO
. oraenv

#---------------------------------------------------
#    Create the database 
#---------------------------------------------------
svrmgrl         <<EOF
@${HOME}/admin/##SID/create/dbcrea01
EOF

#---------------------------------------------------
#  Place in archivelog mode  
#---------------------------------------------------
#cd /bkup_##ENV/##SID/scripts
#. enable_archiving.ksh

#  echo "....dbcrea01.ksh has completed."
