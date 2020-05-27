#!/usr/bin/env bash

isContinue='y'
function isNext()
{
    read -p 'Please confirm whether to perform the next steps?[y/n]' isContinue
    if [ "$isContinue" = "n" ];then
        exit 1
	elif [ "$isContinue" = "y" ];then
		return 0
	else
		isNext
    fi
}
