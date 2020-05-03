#!/bin/bash
unset array
for x in `cat ../config/itennis.conf`
{
    #字符串截取：从左至右第一个'='之前的内容
    #echo ${x%%=*}
    #字符串截取：从左至右第一个'='之后的内容
    #echo ${x#*=}
    array[${#array[@]}]="${x%%=*} ${x#*=}"
}

echo ${#array[@]}
echo ${array["TIMEOUT"]}
