#!/usr/bin/env bash


listname="swl_list.txt"

cat $listname | while read dir_name
do
	cd $dir_name
	sh setup_workload.sh $dir_name
	sh launch_workloads.sh
	cd ..

done

