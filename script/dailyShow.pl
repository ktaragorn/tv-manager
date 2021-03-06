#!/usr/bin/perl -w
#recursive directory listing
#use strict;
use 5.010;
use File::Find;
use Cwd 'abs_path';
use Cwd;
use File::Basename;
use File::Spec::Functions;

my $cwd = dirname(abs_path($0));
my $data = catfile($cwd,basename(abs_path($0),".pl").".txt");
say $data;
my @files = ();

#open file read line
#open (TEMP, ">>".$cwd."\\cheers.txt"); close TEMP;
open (INFILE,"<".qq($data)); #|| die "Can't Open File: $fname\n";
$lastVid = <INFILE>;
close INFILE;
chomp($lastVid);
say $lastVid;
#@fileList
#for 

#loadFiles(); #call
opendir $MYDIR, qq($cwd);
@files=   grep { !/^\./&&!/\.pl$/&&!/\.txt$/ && m/^The.Daily.Show.*.\.avi$/ } readdir($MYDIR);
@files= sort  {lc $a cmp lc $b} @files;
#say @files;
#readdir MYDIR;
closedir $MYDIR;
#say $lastVid;
#print @files;

$num_of_files = @files;
$i=0;#print $num_of_files;
for($i=0;$i<$num_of_files; $i=$i+1){
	if($lastVid eq "" ) {		
		print "No last file\n";
		$nextVid = $files[$i];
		say $nextVid;
		last;
	}
	if($files[$i] eq $lastVid){ 
		##print "Match".$i;
		$nextVid = $files[$i+1];
		if($nextVid eq "") {
			$nextVid = $lastVid;
			}
		#print $nextVid;
		last;
	}
}

#open file to write 
#save
open (OUTFILE, ">".$data) || die "Can't open output file.\n";
print OUTFILE $nextVid;
close OUTFILE;

if($^O eq "MSWin32"){
	$videoPlayer = "C:\\Program Files\\VideoLAN\\VLC\\vlc.exe";
} else {
	if($^O eq "linux"){
		$videoPlayer = "totem";
	}
}

@output =($videoPlayer,catfile($cwd,$nextVid));
say @output;
system (@output)   or print STDERR "couldn't exec foo: $!";

