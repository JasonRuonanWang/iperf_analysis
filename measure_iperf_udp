#!/bin/bash
# ******************************************************
# script for collecting iperf TCP and UDP  measurements on a connection
# run from local-end to remote end
#      remote end should be running
#         iperf -s -u -w 256k -l 128k -p 5011
#         iperf -s -u -l 8950 -p 5011
#
#      udp - runs 1Mbps, 100, 500, 1000, 2000, ..., 9000, 10000, 10100 10200 11000 Gbps
#
#      The following sub-directory will be created if not present
#                 ./iperf-measurements
#      December 8, 2006
#      raons@ornl.gov
# ****************************************************** 

usage()
{
echo "usage: `basename $0` <destination_IP> <num_times>"
exit 1
}

if [ $# -eq 0 ]
then
   usage
fi

destination_IP=$1
num_times=$2

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

   #iperflogfile=./iperf-measurements/iperf-$mydate-$1_udp_63_256.txt
   #iperflogfile=./iperf-measurements/iperf-file-2100M-$mydate-$1_udp_63_256.txt
   iperflogfile=./iperf-measurements/iperf-l8950-e300_9216_9198-$mydate-$1_udp.txt
   #iperflogfile=./iperf-measurements/iperf-file-e300_9216_9198-$mydate-$1_udp.txt
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


###############     collect iperf UDP measurements

   iperf -c $destination_IP -u >> $iperflogfile
   # for BW in 100 500 1000 2000 3000 4000 5000 
   #for BW in  500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 10100 10200 11000
   for BW in  4000 5000 6000 10000 11000
   do
    # for L in 1500 1000 5000 7000 8000 8900 8950 9000 9100 16000 32000 64000
    for L in  8000 8950 9000 9100 16000 
    do
       count=$num_times
       while [ $count -gt 0 ]
       do
           #iperf -c $destination_IP -u -l 63k -w 256k -b "$BW"m -p 5011 >> $iperflogfile
           #iperf -c $destination_IP -u -l 63k -w 256k -b "$BW"m -p 5011 -F /ccs/proj/quadcore/nrao_temp/send_1_2100M_5020.dat >> $iperflogfile
	   sleep 10
           # iperf -c $destination_IP -u -l "$L" -b "$BW"m -p 5011 -F /data/xfs/nrao/send_1_2100M_5020.dat >> $iperflogfile
           iperf -c $destination_IP -u -l 8950 -b "$BW"m -p 5011 >> $iperflogfile
           echo "UDP iperf targetBW=$BW; iteration=$count"
	   count=` expr $count - 1 `
       done
       sleep 100
    done
   done
   
   if [ $? = 0 ]
   then
      echo "file $iperflogfile is successfully created"
   else
      echo "problem creating the file $iperflogfile"
   fi

echo "iperf measurement collection from `hostname` to $destination_IP completed"
