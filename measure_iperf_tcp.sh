#!/bin/bash
# ******************************************************
# script for collecting iperf TCP and UDP  measurements on a connection
# run from local-end to remote end
#      remote end should be running
#         iperf -s -p 5010 -l 8950 -w 32m
#
#      TCP - runs 1 through 10 parallel streams
#
#      The following sub-directory will be created if not present
#                 ./iperf-measurements
#      strated: December 8, 2006
#      last modified: April 28, 2008
#      Nagi Rao, raons@ornl.gov
# ****************************************************** 

usage()
{
echo "usage: `basename $0` <destination_IP> <num_times><max_streams><label>"
exit 1
}

if [ $# -eq 0 ]
then
   usage
fi

destination_IP=$1
num_times=$2
max_streams=$3
label=$4

echo "starting iperf measurments from `host-name` to $1"

mydate=`date +%B-%d-%y-%R`

# make sure the ping-mesurements directory is in order

   iperflogdir=./iperf-measurements
   if [ -r $iperflogdir ]
   then
	echo "directory $iperflogdir exists"
   else
	mkdir $iperflogdir
        if [ $? = 0 ] 
	then
	   echo "directory $iperflogdir created"
	else
	   echo "problem creating the directory $iperflogdir"
	fi
   fi

   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_w300k.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_auto_bic.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_auto_htcp.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_auto_highspeed.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_auto_scalable.txt
   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_tcp_default_E.txt
   #iperflogfile=./iperf-measurements/iperf-file-2100M-$mydate-$1_tcp_default_E.txt
   iperflogfile=./iperf-measurements/iperf-$label-$mydate-times-$num_times-streams-$max_streams.txt
   echo $label
   echo $iperflogfile

   if [ -r $iperflogfile ]
   then
	echo "file $iperflogfile exists"
	rm -f $iperflogfile
        if [ $? = 0 ] 
	then
	   echo "file removed"
	else
	   echo "problem removing the file $iperflogfile"
	fi
   fi

###############     collect iperf TCP measurements

   for ((P=1;P<=max_streams;P++)) 
   # for P in  in 1 2 3 4 5 6 7 8 9 10
   #for P in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
   # for P in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
   do
       count=$num_times
       while [ $count -gt 0 ]
       do
           #iperf -c $destination_IP -P$P -w 300000 >> $iperflogfile
           #iperf -c $destination_IP -P$P >> $iperflogfile
           #iperf -c $destination_IP -P$P -p 5010 >> $iperflogfile
           #iperf -c $destination_IP -P$P -p 5010 -F /ccs/proj/quadcore/nrao_temp/send_1_2100M_5020.dat >> $iperflogfile
           cmd="iperf3 -c $destination_IP -P$P -l 8950 -w 500m"
           echo $cmd
           $cmd >> $iperflogfile
           echo "TCP iperf streams=$P; iteration=$count"
	   count=` expr $count - 1 `
       done
   done
   
   if [ $? = 0 ]
   then
      echo "file $iperflogfile is successfully created"
   else
      echo "problem creating the file $iperflogfile"
   fi

echo "iperf measurement collection from `hostname` to $destination_IP completed"
