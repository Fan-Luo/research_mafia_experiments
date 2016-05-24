#!/usr/bin/env bash

# if [ -n "$listname" ]

listname="swl_list.txt"

# export listname

cat $listname | while read filename
do
	rm -rfr $filename 	
done

