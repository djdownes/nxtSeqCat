#!/usr/bin/perl -w
use strict;
use Cwd;
use Data::Dumper;
use Getopt::Long;
use Try::Tiny;

# Owes gratitude to http://www.perlmonks.org/?node_id=486200
# V1.0, 8 Nov 2017 DJDownes

&GetOptions
(
    "in|samples=s"=>\ my $sample_list,     # --samples/--in       File containing list of name containing {NAME} from fastq {NAME}_S1_L001_R1_001.fastq.gz
    "gz|outgz=i"=>\ my $gz_out,            # --outgz/--gz         Option for zipping concatenated files, use for NGseqBasic, do not use for CCanalyser, --gz 1 to zip
);


open (SAMPLES, $sample_list) or die "Cannot open sample list\n";
   
while (my $sampleID = <SAMPLES>)
{
    chomp($sampleID);
    &doSystemCommand  ("gunzip $sampleID\*.gz 2>> possibleErrors.log");
    print "Concatenating $sampleID files\n";
    my $fastq1 = "$sampleID\_S*_L001_R1_001.fastq";
    my $fastq2 = "$sampleID\_S*_L002_R1_001.fastq";
    my $fastq3 = "$sampleID\_S*_L003_R1_001.fastq";
    my $fastq4 = "$sampleID\_S*_L004_R1_001.fastq";
    my $fastq5 = "$sampleID\_S*_L001_R2_001.fastq";
    my $fastq6 = "$sampleID\_S*_L002_R2_001.fastq";
    my $fastq7 = "$sampleID\_S*_L003_R2_001.fastq";
    my $fastq8 = "$sampleID\_S*_L004_R2_001.fastq";
    &doSystemCommand ("cat $fastq1 $fastq2 $fastq3 $fastq4 1> $sampleID\_R1.fastq 2>> possibleErrors.log");
    &doSystemCommand ("cat $fastq5 $fastq6 $fastq7 $fastq8 1> $sampleID\_R2.fastq 2>> possibleErrors.log");
    if ($gz_out)
        {
        &doSystemCommand ("gzip $sampleID\_*.fastq 2>> possibleErrors.log");
        }
    else
        {
        &doSystemCommand ("gzip $sampleID\_S*.fastq 2>> possibleErrors.log");    
        }
}

exit;

# Sub from perlmonks (http://www.perlmonks.org/?node_id=486200)

sub doSystemCommand
{
    my $systemCommand = $_[0];

    print LOG "$0: Executing [$systemCommand] \n";
    my $returnCode = system( $systemCommand );

    if ( $returnCode != 0 ) 
    { 
        die "Failed executing [$systemCommand]\n"; 
    }
}

