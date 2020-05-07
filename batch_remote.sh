#!/usr/bin/env bash

remoteCmd(){
    declare -a ip_one
    grep -v "^#" $1 | while read line
    do
        i=0
        for word in ${line};
        do
            ip_one[i]=$word
            let i++
        done
        sh $ROOTDIR/core/expect_cmd.sh 22 ${ip_one[1]} ${ip_one[0]} ${ip_one[2]} "$2"
    done
}

remoteScp(){
    declare -a ip_one
    grep -v "^#" $1 | while read line
    do
        i=0
        for word in ${line};
        do
            ip_one[i]=$word
            let i++
        done
        sh $ROOTDIR/core/expect_scp.sh 22 ${ip_one[1]} ${ip_one[0]} ${ip_one[2]} "$2" "$3"
    done
}
