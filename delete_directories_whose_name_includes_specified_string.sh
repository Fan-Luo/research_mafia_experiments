#!/usr/bin/env bash


listname="single_swl_list.txt"


cat $listname | while read filename
do
		
		fff=`find $filename/singleapps -type d -name "*LIB*" | awk -F "[/]" '{print $3}'`
		cd $filename/singleapps
		
		for af in $fff
		do
	    	rm -rfr -d $af
		done
	    
	    cd ..
	    cd ..
done


