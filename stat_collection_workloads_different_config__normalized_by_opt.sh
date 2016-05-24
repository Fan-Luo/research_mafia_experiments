#!/usr/bin/env bash


listname="swl_list.txt"

cat $listname | while read dir_name
do
	cd $dir_name
	perl stat_collection_workloads.pl
	cd ..

done

perl stat_collection_all_result.pl


