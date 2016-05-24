#!/usr/bin/env bash

listname="single_swl_list.txt"


cat $listname | while read dir_name
do
	cp -r ./setup_workload.sh ./$dir_name
done


