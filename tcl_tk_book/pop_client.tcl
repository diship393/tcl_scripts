#!/usr/bin/tclsh

set popHost example.com 
set popLoginID popclient
set popPasswd SecretPassword 

set popClient [socket $popHost 110]

set line [gets $popClient]

if {[string first "+OK" $line] != 0} {
    puts "ERROR: Did not get expected '+OK' prompt."
    puts "Recieved: $line"
    exit;
}

puts $popClient "user $popLoginID"
flush $popClient

set response [gets $popClient]
if {[string match "+OK*" $response] == 0} {
    puts "ERROR: did not get expected '+OK' prompt"
    puts "Recieved: $response"
    exit;
}

# send password 
puts $popClient "pass $popPasswd"
flush $popClient

set message [gets $popClient]
if {![string match "+OK*" $message]} {
    puts "ERROR: did not get expected '+OK' prompt"
    puts "Recieved: $message"
    exit;
}

puts [string range $message 3 end]
close $popClient
exit;