#!/bin/ksh
#----------------------------------------------------------------------------
#
#	File: build_db.ksh
#
#	Author: Bhavesh Patel
#
#	Date: 9/1/98
#
#	Purpose: To create the necessary scripts to create a database.
#
#----------------------------------------------------------------------------


if [[ $# -ne 3 ]]
then
	echo "Usage: build_db.ksh <oracle-sid> <ORACLE_HOME> <Version e.g. 8.1.5>"
	exit -1
fi	

ORACLE_SID=$1
ORACLE_HOME=$2
VERSION=$3


#----------------------------------------------------
# Build the necessary directory structure.
#----------------------------------------------------
build_ds()
{

echo "...Building the directory structure..."

#df -k | grep ora > /tmp/build_ds.lst
ls -d /ora* > /tmp/build_ds.lst

if [ ! -s /tmp/build_ds.lst ]
then
	echo "No /ora* directories"
	exit -2
fi

cat /tmp/build_ds.lst | while read LINE
do
	#MNTPNT=`echo $LINE | awk '{print $6}'`	
	MNTPNT=$LINE
        mkdir ${MNTPNT}/${ORACLE_SID}
	chmod 755 ${MNTPNT}/${ORACLE_SID}
        mkdir ${MNTPNT}/${ORACLE_SID}/dbfiles
	chmod 755 ${MNTPNT}/${ORACLE_SID}/dbfiles
done

# Create under backup directory.
mkdir -p /orabkup01/${ORACLE_SID}/archive
chmod 755 /orabkup01/${ORACLE_SID}/archive
mkdir -p /orabkup01/${ORACLE_SID}/export
chmod 755 /orabkup01/${ORACLE_SID}/export

mkdir -p ${HOME}/admin/${ORACLE_SID}/arch
chmod 755 ${HOME}/admin/${ORACLE_SID}/arch

mkdir ${HOME}/admin/${ORACLE_SID}/bdump
chmod 755 ${HOME}/admin/${ORACLE_SID}/bdump

mkdir ${HOME}/admin/${ORACLE_SID}/cdump
chmod 755 ${HOME}/admin/${ORACLE_SID}/cdump

mkdir ${HOME}/admin/${ORACLE_SID}/udump
chmod 755 ${HOME}/admin/${ORACLE_SID}/udump

mkdir ${HOME}/admin/${ORACLE_SID}/create
chmod 755 ${HOME}/admin/${ORACLE_SID}/create

mkdir ${HOME}/admin/${ORACLE_SID}/pfile
chmod 700 ${HOME}/admin/${ORACLE_SID}/pfile

mkdir ${HOME}/admin/${ORACLE_SID}/ctl
chmod 700 ${HOME}/admin/${ORACLE_SID}/ctl

mkdir ${HOME}/admin/${ORACLE_SID}/log
chmod 755 ${HOME}/admin/${ORACLE_SID}/log

}


#-----------------------------------------------------
# Create the oratab entry.
#-----------------------------------------------------
cr_oratab_entry()
{

echo "....Creating entry in oratab"

grep "^${ORACLE_SID}:" /var/opt/oracle/oratab

if [[ $? -eq 0 ]]
then
	echo "Entry ${ORACLE_SID} already exist in the ORATAB. Please verify." 
else
	echo "${ORACLE_SID}:${ORACLE_HOME}:Y" >> /var/opt/oracle/oratab
fi

}


#-----------------------------------------------------
# Database creation scripts.
#-----------------------------------------------------
build_db_creation_scripts()
{

echo "..... Building the db creation scripts"

echo "s/##ENV/ora/g" > /tmp/sed.scr 
echo "s/##SID/${ORACLE_SID}/g" >> /tmp/sed.scr 
echo "s/##VER/${VERSION}/g" >> /tmp/sed.scr 

sed -f /tmp/sed.scr ${HOME}/dba/bin/install/dbcrea01.ksh > ${HOME}/admin/${ORACLE_SID}/create/dbcrea01.ksh
sed -f /tmp/sed.scr ${HOME}/dba/bin/install/dbcrea01.sql > ${HOME}/admin/${ORACLE_SID}/create/dbcrea01.sql
sed -f /tmp/sed.scr ${HOME}/dba/bin/install/init${VERSION}.ora > ${HOME}/admin/${ORACLE_SID}/pfile/init${ORACLE_SID}.ora

chmod 755 ${HOME}/admin/${ORACLE_SID}/create/dbcrea01.ksh
chmod 755 ${HOME}/admin/${ORACLE_SID}/create/dbcrea01.sql
}


dir_perm_oraenv()
{
echo "...Checking directory permissions".

> /var/opt/oracle/junk

if [[ $? -ne 0 ]]
then
	echo "Could not write in /var/opt/oracle."
	exit -3
fi

rm /var/opt/oracle/junk

> /usr/local/bin/junk

if [[ $? -ne 0 ]]
then
	echo "Could not write in /usr/local/bin."
#	exit -3
fi

rm /usr/local/bin/junk

# Copy the oraenv and dbhome.

if [[ ! -f /usr/local/bin/oraenv ]]
then
	cp ${ORACLE_HOME}/bin/oraenv /usr/local/bin
	cp ${ORACLE_HOME}/bin/dbhome /usr/local/bin
fi

echo 'export OH=${ORACLE_HOME}' >> /usr/local/bin/oraenv

if [ ! -d /orabkup01 ]
then
	echo "/orabkup01 does not exist"
	#exit -4
fi
#
}


#------------------------------------------
# Main logic.
#------------------------------------------

# Check directory permissions.
dir_perm_oraenv

# Build the directory structure.
build_ds

# Create the oratab entry.
cr_oratab_entry

# Create the init ora link.
cd ${ORACLE_HOME}/dbs
ln -s ${HOME}/admin/${ORACLE_SID}/pfile/init${ORACLE_SID}.ora .

# Build the db creation scripts.
build_db_creation_scripts
