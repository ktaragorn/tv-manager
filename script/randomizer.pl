#!/usr/bin/perl -w 
use strict;

use File::Find;
use Cwd 'abs_path';
use Cwd;
use File::Basename;
use File::Spec::Functions;
use 5.10.1;


my $videoPlayer = "xdg-open";
my $cwd = dirname(abs_path($0));

#if param is relative it is attached to path, if absolute it is used as is
if(exists($ARGV[0])){
	$cwd = $cwd.'/'.$ARGV[0];
	$cwd = $ARGV[0] if(file_name_is_absolute( $ARGV[0]));
	$cwd =~ s/\/$//;
}


die "$cwd isnt a directory" unless -d $cwd;
say "Randomizing from $cwd";

my @fileList = loadRecursiveFiles($cwd);
my $randVid = "" ;
my $count =0;
$randVid = $fileList[rand(scalar(@fileList))] until($randVid =~ /.avi$/|| $count++>10);
print $randVid;
system ($videoPlayer,$randVid)   or print STDERR "couldn't exec foo: $!";

sub loadRecursiveFiles{
	my $dir = shift;
	my @list = loadFiles($dir);
	s/^/$dir\// foreach(@list); #making paths absolute
	#say @list;
	my @finalList;
	foreach(@list) {
		if( -d $_){#print "dir";
			my @subList = loadFiles($_);
			my $subDir = $_;

			$_ = $subDir."/".$_ foreach (@subList);
			@finalList = (@finalList,@subList);
		}else{
			push  (@finalList,$_) ;
		}

	}
	return @finalList;
}

sub loadFiles{
	my $dir = shift;
	opendir MYDIR, qq($dir);
	my @files=   grep { !/^\./&&!/\.pl$/&&!/\.txt$/ } readdir(MYDIR);
	@files= sort @files;
	closedir MYDIR;
	return @files;
}

