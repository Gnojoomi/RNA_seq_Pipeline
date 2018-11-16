#usr/bin/perl 
#use warnings;
#use strict;
use Data::Dumper;

my $transcripts;
$transcripts=$ARGV[0];
my $final_transcripts;
$final_transcripts=$ARGV[1];


open (my $fh, '<', $transcripts);
my @names;
my @sequences;
while (my $line = <$fh>)
{
	chomp $line;
	my $first_letter;
	$first_letter = substr($line,0,1);
	if ($first_letter eq ">")
	{
	    push(@names,$line);
	}
	if ($first_letter ne ">")
	{
	    push(@sequences,$line);
	}
}
close $fh;

my @final_sequences;
my @final_names;
my $last_letter;

for my $i (0 .. @names)
{
	my $last_letter;
	$last_letter = substr($names[$i],-1);
	if ($last_letter eq "+")
	{
	    push(@final_names,$names[$i]);
	    push(@final_sequences,$sequences[$i]);
	}
	if ($last_letter eq "-")
	{
	    my $comp_seq;
	    $comp_seq=$sequences[$i];
            $comp_seq=~tr/ATGC/TACG/;
	    my $compliment;
            $compliment= reverse $comp_seq;
	    push(@final_names,$names[$i]); 
	    push(@final_sequences,$compliment);	
	}
}

open (my $fv, '>',$final_transcripts);
for my $p (0 .. @final_names)
{
	chop $final_names[$p];
	print $fv ($final_names[$p],"\n") ;
	print $fv ($final_sequences[$p],"\n");
}
close $fv;




