# This script was developed to eliminate clusters for which at least one pair (CHR-POS) is reiterative

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_readCLUSTERING_5.txt

open FILE_reiterPAIRS, "<$ARGV[0]";     # $ARGV[0] = ../Output_reiterPAIRS.txt
while (<FILE_reiterPAIRS>){
	chomp;
	@PAIR=split(/\s+/,$_);
	$CHR=$PAIR[0];
	$POS=$PAIR[1];
	
	$LIST{$CHR}{$POS}=1;
}
close FILE_reiterPAIRS;

$INTERVAL=2000;
open FILE_CClist, "<$ARGV[1]";  # $ARGV[1] = ../Output_readCLUSTERING_4_minN.txt
LINE:
while (<FILE_CClist>){
	chomp;
	@CLUSTER=split(/\s+/,$_);
	$CHR=$CLUSTER[0];	# $CHR = $CHR1 = $CLUSTER[0] = $CLUSTER[2] = $CHR2
	$POS1=$CLUSTER[1];
	$POS2=$CLUSTER[3];
	
	if ((exists $LIST{$CHR}{$POS1}) || (exists $LIST{$CHR}{$POS2})){
		goto LINE;
	}
	print FILE_print "$_\n";
}
close FILE_CClist;

close FILE_print;