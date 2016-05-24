#!/usr/bin/env bash


listname="single_swl_list.txt"

cat $listname | while read dir_name
do
	cd $dir_name
	sh setup_singleapp.sh /mul_app_studies/$dir_name
	sh launch_singleapp.sh
	cd ..

done

