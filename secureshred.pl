#! /usr/bin/perl

# David Demianovich, Ross Cooper, David Londono
# UCF CIS 4361 - Spring 2015

$option = shift();

if ($option eq "-d"){ print "-d\n";}
	elsif($option eq "-f"){ print "-f\n";}
	elsif($option eq "-t") { print "-t\n";}
	elsif($option eq "-r") { print "-r\n"}
	elsif($option eq "-s") { print "-s\n"}
	elsif($option eq "-h") { prhelp(); }
	else { 
		print "unrecognized command. please try again. use the flag '-h' to display the help menu.\n";
		exit;
	}

# function to print help menu
sub prhelp {
	print <<HELP;
	Usage:
	-d <directory>: reads the list of files in the directory and computes the md5 for each one
	-f <file>: reads a specific file and computes its md5
	-t <file>: tests integrity for the files with the recorded md5s
	-r <file>: removes a file from the recorded md5 database
	-s <file>: securely shred a file in the system

HELP
}
