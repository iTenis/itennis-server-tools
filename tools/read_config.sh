#!/bin/bash

declare -a ip_one
grep -v "^#" $1 | while read line
do
    i=0
    for word in ${line};
    do
        ip_one[i]=$word
        let i++
    done
    echo ${ip_one[0]} ${ip_one[1]} ${ip_one[2]}
done

