# !/usr/bin/env perl  -w
use strict;
my $confINTERVAL=200;
my $samtools = "/path/to/samtools-0.1.19/samtools";
open FILE, "<$ARGV[0]";		# $ARGV[0] = callingGENES1.txt
while (<FILE>){
	chomp;
	my @GENE=split(/\t/,$_);
	my $confSTART=$GENE[1]-$confINTERVAL;
	my $confEND=$GENE[2]+$confINTERVAL;
	# print "$GENE[0]:$confSTART-$confEND\n";
	qx{$samtools view /path/to/accepted_hits.bam $GENE[0]:$confSTART-$confEND | awk '\$5>=50 && (\$7!=\$3 || \$7!="=" || \$7!="*") && (\$4>$confSTART && \$4<$confEND && (\$8<$confSTART || \$8>$confEND))' >> Output_CHIMERICreads_minMAPQ50.sam};
}
close FILE;
