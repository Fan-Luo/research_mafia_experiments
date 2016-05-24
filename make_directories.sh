#!/usr/bin/env bash

# if [ -n "$listname" ]

listname="list.txt"

# export listname

cat $listname | while read filename
do
	mkdir $filename 	
done

