#!/usr/bin/env bash

listname="swl_list.txt"


cat $listname | while read dir_name
do
	cp -r ./apps.txt  ./$dir_name
	cp -r ./apps2.txt  ./$dir_name
	cp -r ./apps3.txt  ./$dir_name
	cp -r ./apps4.txt  ./$dir_name

done


