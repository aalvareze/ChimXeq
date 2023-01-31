# !/usr/bin/env perl  -w
use strict;

open FILE1, "<$ARGV[0]";    # $ARGV[0] = ../cases.list
my %HASH;
while (<FILE1>){
	chomp;
	my @LINE=split(/\t/,$_);
	my $ID=$LINE[0];

	if (exists $HASH{$ID}){
		goto END;
	}
	$HASH{$ID}=1;

	END:
}
close FILE1;

my $samtools="/path/to/samtools-0.1.19/samtools";

foreach my $KEY_ID (sort {$a<=>$b} keys %HASH){

	qx{mkdir /path/to/$KEY_ID};
	my $PRINT="Output_CHIMERICreads.sam";
	my $PATH_PRINT="/path/to/$KEY_ID" . "/" . "$PRINT";

	my $BAM="$KEY_ID" . "." . "Chimeric.sortedByCoord.out.bam";
	my $PATH_BAM="/path/to/$BAM";

	my $confINTERVAL=200;
	my $PATH="/path/to/callingGENES1.txt";
	open FILE2, "<$PATH";
	while (<FILE2>){
		chomp;

		if ($_=~/Chromosome/){
			goto END;
		}

		my @GENE=split(/\t/,$_);
		my $confSTART=$GENE[1]-$confINTERVAL;
		my $confEND=$GENE[2]+$confINTERVAL;

		qx{$samtools view $PATH_BAM $GENE[0]:$confSTART-$confEND | awk '(\$7!=\$3 && \$7!="=" && \$7!="*") && (\$4>$confSTART && \$4<$confEND && (\$8<$confSTART || \$8>$confEND))' >> $PATH_PRINT};

		END:
	}
	close FILE2;

}