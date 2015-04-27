#! /usr/bin/perl

# David Demianovich, Ross Cooper, David Londono
# UCF CIS 4361 - Spring 2015
# secure file shredder / integrity checker

use Digest::MD5 qw(md5 md5_hex md5_base64);

our $option = shift();
our $file = shift();  # placeholder for second command line arguement, may be file or directory
our $OS = $^O;  # determine operating system

if ($option eq "-d"){ print "-d\n"; dirCompute();}
	elsif($option eq "-f"){ print "-f\n";}
	elsif($option eq "-t") { print "-t\n";}
	elsif($option eq "-r") { print "-r\n"}
	elsif($option eq "-s") { print "-s\n"}
	elsif($option eq "-h") { prhelp(); }
	else { 
		print "unrecognized command. please try again. use the flag '-h' to display the help menu.\n";
		exit;
	}


# compute hashes on all files inside provided directory (-d option)
sub dirCompute {
	my $dirname = $file;
	my $hash = 0;	
	
	# open database
	dbmopen(%MD5, "md5db", 0666);	
		
	# open directory provided by user
	opendir(my $dh, $dirname) || die "cannot opendir $dirname: $!";
	
	# begin interating through each file in directory	
	while(readdir $dh) {		
		my $filename = "$dirname/$_";
		print "FIle NAME: $filename\n";
		# open file and compute md5
		open (my $fh, '<', $filename) or die "cannot open '$filename': $!";
		binmode($fh);
		$md5 = Digest::MD5->new;
		while(<$fh>) {
			$md5->add($_);
		}
		close($fh);
		my $hash = $md5->hexdigest;	
		print "$hash $filename\n";
		
		# add filepath and md5 to database 
		$MD5{$filename} = $hash;
		
	}
	
	# iterate through md5 database (for testing purposes)	
	while (($key,$val) = each %MD5) {
			print $key, ' = ', unpack('a32',$val), "\n"; 
		}

	# close directory and dbm handlers	
	closedir $dh;	
	dbmclose(%MD5);
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
