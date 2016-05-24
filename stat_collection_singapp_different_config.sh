#!/usr/bin/env bash


listname="single_swl_list.txt"

cat $listname | while read dir_name
do
	cd $dir_name
	perl stat_collection_single.pl
	cd ..

done

perl stat_collection_single_result_swls.pl


