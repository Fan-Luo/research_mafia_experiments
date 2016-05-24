#!/usr/bin/env bash


listname="swl_list.txt"

cat $listname | while read dir_name
do
	cd $dir_name
	perl find_sentence_in_files.pl
	cd ..

done

perl find_sentence_all_results.pl


