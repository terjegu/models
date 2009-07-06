#!/usr/bin/perl
#
# Simple script that reads all TextGrid files in a directory and produces
# an HTK master label file (MLF). The TextGrid files are assumed to be
# single tiered interval tier label files.
#
# Invocation: TG2mlf.pl -i <source directory> -o <output mlf file>

use Getopt::Std;

# Read input switches
getopts('i:o:h');
if ($opt_i){$dir=$opt_i;}
if ($opt_o){$mlffile=$opt_o;}
if ((! $opt_o) || (! $opt_i) || ($opt_h)){
    print "Invocation: TG2mlf.pl -i <source directory> -o <output mlf file>\n";
    exit;
}
$HTKConst=10000000;
# Get list of TextGrid files in source directory
@filelist=&dirmatch_end("$dir","TextGrid");
# Open MLF file and write header
open(MLF,">$mlffile") || die "Could not open $mlffile for writing\n";
print MLF "\#!MLF!\#\n";
# For each source file, parse xml content to obtain segment start and ends,
# convert to HTK format and write to target MLF
for ($i=0;$i<=$#filelist;$i++){
    $file="$dir" . "/" . "$filelist[$i]";
    open(TG,"$file")  || die "Could not open $file for reading\n";
    $inint=0;
    while(<TG>){
        chomp;
        if ($_ =~ /name =/){
            ($dum,$fname)=split(/"/,$_);
            print MLF "\"\*/$fname\.lab\"\n";
            next;
        }
        if (($_ =~ /intervals / ) && ($inint==0)){
            $inint=1;
            next;
        }
        if ($inint == 1) {
            if ($_ =~ /xmin =/){
                ($dum,$start)=split(/ = /,$_);
                $HTime=int($start*$HTKConst);
                print MLF "$HTime ";
                next;
            }
            if ($_ =~ /xmax =/){
                ($dum,$start)=split(/ = /,$_);
                $HTime=int($start*$HTKConst);
                print MLF "$HTime ";
                next;
            }
            if ($_ =~ /text =/){
                ($dum,$tag)=split(/"/,$_);
                print MLF "$tag\n";
                $inint=0;
                next;
            }
        }
    }
    close(TG);
    print MLF ".\n";
}

sub dirmatch_end { # return file names in directory ending with a specified string
	local($dir,$instr)=@_;
	opendir(DIR,$dir) || die "Could not open directory $dir\n";
	local (@fns)=readdir(DIR);
	closedir(DIR);
	return grep(/$instr$/,@fns); # keep only files ending with the given string
}
