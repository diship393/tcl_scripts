#!/usr/bin/tclsh

puts "\nOpening a Pipe\n"
set pipe [open "|ls /" "r"]

puts "pipe = $pipe"

# read the o/p of the ls command

while {![eof $pipe]} {
        set length [gets $pipe lsLine]
        puts "$lsLine"
}

# output of the script

if {0} {

Opening a Pipe

pipe = file5
Applications
bin
cores
dev
etc
home
Library
opt
private
sbin
System
tmp
Users
usr
var
Volumes

}
