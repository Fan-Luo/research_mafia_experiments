#!/usr/bin/env bash


listname="swl_list.txt"
filentodel="list.txt"


cat $listname | while read filename
do
	cat $filentodel | while read delfile
	do
		cd $filename/workloads
		rm -rf $delfile
	    cd .. 
	    cd ..
	done
done


