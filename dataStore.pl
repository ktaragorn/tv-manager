#!/usr/bin/perl -w 
use strict;
use warnings;
use diagnostics;

use DBI;
use DBD::CSV;
use 5.10.1;
use File::Spec::Functions;
use SQL::Interp ':all';
require Tk::ErrorDialog;

#windows compatibility
BEGIN {
if ( substr ( $^O, 0, 5 ) eq q{MSWin} ) {
	if ( $ENV{HOME} ) {
	# leave as is
	}
	elsif ( $ENV{USERPROFILE} ) {
	$ENV{HOME} = $ENV{USERPROFILE};
	}
	elsif ( $ENV{HOMEDRIVE} and $ENV{HOMEPATH} ) {
	$ENV{HOME} = $ENV{HOMEDRIVE} . $ENV{HOMEPATH};
	}
	else {
	$ENV{HOME} = '.';
	}
} }


my $tableLocation = $ENV{HOME};
my $tableName = "tvmandb";

my $dbh = DBI->connect ("dbi:CSV:f_dir=$tableLocation") or die "Cannot connect: $DBI::errstr";
$dbh->{RaiseError} = 1;

my $getShow = $dbh-> prepare (qq(SELECT id,name,path,lastPlayed,pattern,depth,category,defaultmode FROM $tableName WHERE id = ?));
my $maxId =  $dbh-> prepare (qq(SELECT id FROM $tableName ORDER BY id desc));

createTable() unless( -e catfile($tableLocation,$tableName));

#returns largest id + 1
sub uniqueId(){
	return $dbh->selectrow_array($maxId)+1;
}

sub showCount{
	$dbh->do("SELECT * FROM $tableName");
}
#TODO:update to interp?
sub createTable{
	say "Table Doesnt exist, creating it";
	$dbh->do (qq(CREATE TABLE $tableName (id INT, name CHAR, path CHAR, lastPlayed CHAR, pattern CHAR, depth INT, category CHAR,defaultmode CHAR))) 
		or die "Cannot create table: " . $dbh->errstr();
}

sub getShowList {
	my %list = %{$dbh->selectall_hashref("select id, name,category from $tableName","id")};
	#my (%returnList,$key,$value);
	
	#$returnList{$key}= $value->{name} while(($key,$value) = each %list);
	return %list;
}

sub getCategoryList{
	my @catList = @{ $dbh->selectcol_arrayref("SELECT DISTINCT category FROM $tableName")};
	return @catList;
}

#TODO:update to interp?
sub getShowDetails{		
	$getShow -> execute(shift);	
	my %show = %{ $getShow->fetchrow_hashref()} ;
	say "Retrieving details of $show{name}";
	return %show;
}

sub saveShow{
	my %show = @_;	
	my ($sql, @bind) = sql_interp "UPDATE $tableName SET",  \%show, 'WHERE id = ', \$show{id};
	$dbh->do($sql,undef,@bind) or die;
}

sub deleteShow {
	my $id=shift;
	$dbh->do("DELETE FROM $tableName WHERE id=?",undef,$id);
}

sub addShow{
	my %show = @_;
	$show{id} = uniqueId();# auto increment
		
	my ($sql,@bind) = sql_interp "INSERT INTO $tableName", \%show;
	$dbh->do($sql,undef,@bind) or die;
	
	
	#LEFT FOR REFERENCE - works
	#my $numParams = scalar keys %show;
	#my $paramString = "?," x $numParams;
	#$paramString =~ s/,$//;
	#my $statement ="INSERT INTO $tableName (".join (',',keys %show).") VALUES ($paramString)";
	#my $sth = $dbh->prepare ($statement)or die "Cannot create statement: " . $dbh->errstr();
	#$sth -> execute(values %show);
}

#unified into the save show function
#sub savePattern{
#	my ($name, $pattern) = @_;	
#	$updatePattern -> execute( $pattern,$name);
#}

#sub savePath{
#	my ($name, $path) = @_;	
#	$updatePath -> execute( $path,$name);
#}


#sub saveLastViewed{
#	my ($name, $lastPlayed) = @_;
#	$updateLastViewed -> execute( $lastPlayed,$name);
#}

#my $updatePattern = $dbh-> prepare (qq(UPDATE $tableName SET pattern=? WHERE name=?));
#my $updateLastViewed = $dbh-> prepare (qq(UPDATE $tableName SET lastPlayed=? WHERE name=?));
#my $updatePath = $dbh-> prepare (qq(UPDATE $tableName SET path=? WHERE name=?));
1;
