#!/usr/bin/expect

set name [lindex $argv 0];

spawn rad project init
expect ": $";
send "$name\r"
interact


