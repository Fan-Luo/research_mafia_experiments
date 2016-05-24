#!/usr/bin/env bash

listname="single_swl_list.txt"


cat $listname | while read dir_name
do
	cp -r ./script_base_singleapp.pbs ./$dir_name
	cp -r ./script_base_workloads.pbs  ./$dir_name
	cp -r ./setup_singleapp.sh  ./$dir_name
	cp -r ./setup_workload.sh  ./$dir_name

done


