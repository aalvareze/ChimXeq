open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_COUNTINGnTSR_1.txt

$COUNT=0;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_readCLUSTERING_1_minN.txt
while (<FILE>){
	chomp;
	@CLUSTER=split(/\s+/,$_);
	$TSR=$CLUSTER[4];
	
	$COUNT=$COUNT+$TSR;
}
close FILE;

print FILE_print "$COUNT\n";

close FILE_print;