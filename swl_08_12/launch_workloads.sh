#!/bin/bash

function launch {
    #if  grep -wq $1 tuples_error.txt
    #then
		#echo "found"
    #elif grep -wq $2 tuples_error.txt
    #then
		#echo "found"
    #elif grep -wq $1 tuples_unnecessary.txt
    #then
		#echo "found"
    #elif grep -wq $2 tuples_unnecessary.txt
    #then
		#echo "found"
    #else
        cd workloads/$1
        rm _cuobjdump_*
        rm *.txt
        qsub pbs_$1.pbs
        cd -
    #fi
}

mylist=`cat apps.txt`
set -- $mylist

for APP1; do
        shift
        for APP2; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
done

mylist2=`cat apps2.txt`
set -- $mylist2

for APP1; do
        shift
        for APP2; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
done

mylist3=`cat apps3.txt`
set -- $mylist3

for APP1; do
        shift
        for APP2; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
done

mylist4=`cat apps4.txt`
set -- $mylist4

for APP1; do
        shift
        for APP2; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
done
for APP1 in $mylist; do
        launch $APP1\_$APP1 $APP1\_$APP1
        for APP2 in $mylist2; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done
for APP1 in $mylist; do
        for APP2 in $mylist3; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done

for APP1 in $mylist; do
        for APP2 in $mylist4; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done

for APP1 in $mylist2; do
        launch $APP1\_$APP1 $APP1\_$APP1
        for APP2 in $mylist3; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done

for APP1 in $mylist2; do
        for APP2 in $mylist4; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done
for APP1 in $mylist3; do
        launch $APP1\_$APP1 $APP1\_$APP1
        for APP2 in $mylist4; do
            launch $APP1\_$APP2 $APP2\_$APP1
        done
		shift
done

for APP1 in $mylist4; do
        launch $APP1\_$APP1 $APP1\_$APP1
done

