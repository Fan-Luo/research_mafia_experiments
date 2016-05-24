#!/usr/bin/env bash


listname="swl_list.txt"



cat $listname | while read dir_name
do
	cp -r  swl_01_01 $dir_name
done


