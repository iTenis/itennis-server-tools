#!/bin/sh
# \
exec expect -- "$0" ${1+"$@"}
set timeout 5

set port [lindex $argv 0]
set username [lindex $argv 1]
set host [lindex $argv 2]
set password [lindex $argv 3]
set cmd [lindex $argv 4]

spawn ssh  -p $port $username@$host "$cmd"
expect {
    "(yes/no)?" {send "yes\n";exp_continue}
    "assword:" {send "$password\n";exp_continue}
    "*denied*" {exit -1}
    "timeout" {exit 127}
}
catch wait result
set ret [lindex $result 3]
exit $ret
