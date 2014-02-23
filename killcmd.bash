#!/bin/bash
# Kill -9 by cmnd name
# @author James Porcelli

if [ $# -ne 1 ] ;
then
	echo "Usage: ./killcmnd [command_name]"
	exit 1
fi 

# The command name
arg=$1

# Remove output on stderr because of DYLD enviroment variable being exported by .bash_profile
# @TODO- only remove the DYLD warning/error not relevent error output

`touch tmp 2> /dev/null`

`ps -x 2> /dev/null | grep "${arg}" 2> /dev/null | cut -c 1-5 2> /dev/null > tmp`

lc=`wc -l tmp | sed 's/[ a-z]//g'`

lc=$(($lc-3))

# Remove the results of ps that were included due to the execution of this program i.e
# 3 calls to unix system functions, ps, grep, cut, that were included in the result set

`head -"${lc}" tmp > tmp_`

`rm tmp`
`cp tmp_ tmp`
`rm tmp_`

# tmp now holds all pids for the process given by the specified command name, we can 
# now kill -9 them

# first output the list of pids found so the user can confirm they want to kill -9
# every process on the list

while read line
do
	echo "pid: $line"
done < "tmp"

echo "Do you want to remove the processes given by the following pid values (y/n): "

read res
if [ $res = "y" ] ;
then
	while read line
	do
		echo "Attempting to kill -9 pid $line"
		`kill -9 "$line"`
	done < "tmp"

	echo "Kill -9 by cmd name complete. Goodbye"
	exit 0
else
	echo "Exiting without terminating any processes"
	exit 0
fi









