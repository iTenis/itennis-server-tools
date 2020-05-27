#!/bin/sh
# \
exec expect -- "$0" ${1+"$@"}
set timeout -1

set port [lindex $argv 0]
set username [lindex $argv 1]
set host [lindex $argv 2]
set password [lindex $argv 3]
set source [lindex $argv 4]
set dest [lindex $argv 5]

spawn scp -P $port -r $source $username@$host:$dest
expect {
    "(yes/no)?" {send "yes\n";exp_continue}
    "assword:" {send "$password\n";exp_continue}
    "*denied*" {exit -1}
    "timeout" {exit 127}
}
