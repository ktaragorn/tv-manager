#!/usr/bin/perl -w 
use strict;
use warnings;
use diagnostics;

use File::Basename;
use 5.10.1;
use Sort::Naturally;
use File::Find::Rule;
use Cwd 'abs_path';
use File::Spec::Functions 'rel2abs';
 use Switch;

sub copyhash {	
	my($key,$value);
	my ($dest,$source) = @_;
	$dest->{$key}=$value while(($key,$value) = each %$source);
}

sub clearhash {
	my $hash = shift;
	$hash->{$_}="" foreach keys %$hash;
}

my @video_file_types =("*.avi","*.mp4","*.mkv", "*.flv");

#TODO spanish names? eg 30 Rock/Season 5/05x13
sub loadRecursiveFiles {
	my ($path,$pattern,$depth) = @_;
	my $defDepth = 2;
	$pattern = '.*' unless $pattern;
	say "Using a default depth of $defDepth"  unless ( $depth);
	$depth = $defDepth unless $depth;
	$path = abs_path($path);
	
	 my @list = File::Find::Rule->maxdepth($depth)
					->relative
					->file->name(qr/$pattern/i)->name(@video_file_types)
					->in($path);

	#extracting immediate folder names - this should be suffient. Using hash to store unique paths
	my %dirs = ();
	foreach my $file( @list){
		next if dirname($file) eq "." ; # ignore if dirname returns . => top level file and no dir name
		$dirs{dirname $file} = 1;
		
	}
	@list = nsort(keys (%dirs ), @list) ;#add folders to file list
	return @list;
	
}

sub is_video{
	my $name = shift;

	foreach my $type (@video_file_types){
		return 1 if $name =~/\$type$/;
	}
	return 0;
}


sub fileName{
	return basename($_[0]);
}

sub play{

	my $videoPlayer;
	my ($path,$relFile) = @_;
	
	my $file = rel2abs($relFile,$path);
	say "Playing $file";

	switch($^O){
		case 	"MSWin32" {$videoPlayer = "\"C:\\Program Files (x86)\\Windows Media Player\\wmplayer.exe\""." \"";}	
		case 	"linux"	      {$videoPlayer = "xdg-open";}
	}

	my @output =($videoPlayer,$file);
	if(fork()){
		exec (@output) ==0  or die  "couldn't play($file): $!";
		exit 1;
	}
}
#print $_,"\n" foreach loadRecursiveFiles($ARGV[0]);
1;

#replacing with File::Find::Rule
#sub loadRecursiveFiles{
#	my ($path,$pattern,$depth) = @_;
#	my $defDepth = 2;
#	$pattern = '.*' unless defined $pattern;
#	say "Using a default depth of $defDepth"  unless defined( $depth);
#	$depth = $defDepth unless defined $depth;
#	$path = abs_path($path);

#	my @list = loadFiles($path);
#	$depth --;
#	$_= rel2abs ($_,$path) foreach(@list); #making paths absolute#s/^/$path\//
#	#say @_,@list;


#	my @finalList;
#	foreach(@list) {
#		if( -d $_ && $depth != 0){#print "dir";
#			my @subList = loadRecursiveFiles($_,$pattern,$depth);
#			#my $subDir = $_;

#			#$_ = $subDir."/".$_ foreach (@subList);
#			@finalList = (@finalList,@subList);
#		}else{
#			push  (@finalList,$_) ;
#		}

#	}
#	
#	@finalList = grep (/\.avi$/&&/$pattern/, @finalList);#file format Check and check file name format
#	return @finalList;
#}


# &&!/\.pl$/&&!/\.txt$/
# sub loadFiles{
# my $dir = shift;

# # opendir MYDIR, qq($dir);
# my @files= grep { !/^\./}  readdir(MYDIR); #eliminate . and .. 
# @files= nsort @files; #using natural sort so it sorts numbers correctly
# closedir MYDIR;
# return @files;
# }
