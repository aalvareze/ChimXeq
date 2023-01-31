# This script was developed to reject false-positive clusters and chromosomal rearrangements

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_readCLUSTERING_CANDIDATElist.txt

$INTERVAL=200;
open FILE_FPlist, "<$ARGV[0]";  # $ARGV[0] = ../COMPLETE_FPlist.txt
while (<FILE_FPlist>){
	chomp;
	@PAIR=split(/\s+/,$_);
	$CHR=$PAIR[0];
	$POS=$PAIR[1];
	$DES=$PAIR[2];
	
	for ($POSITION=($POS-$INTERVAL) ; $POSITION<=($POS+$INTERVAL) ; $POSITION+=100){
		$FPlist{$CHR}{$POSITION}[0]=$DES;
	}
}
close FILE_FPlist;

open FILE_CClist, "<$ARGV[1]";      # $ARGV[1] = ../Output_readCLUSTERING_5.txt
LINE:
while(<FILE_CClist>){
	chomp;
	@CLUSTER=split(/\s+/,$_);
	$CHRM=$CLUSTER[0];	# $CHRM = $CHR1 = $CLUSTER[0] = $CLUSTER[2] = $CHR2
	$POS1=$CLUSTER[1];
	$POS2=$CLUSTER[3];
	
	for ($POSITION1=($POS1-$INTERVAL) ; $POSITION1<=($POS1+$INTERVAL) ; $POSITION1+=100){
		if (exists $FPlist{$CHRM}{$POSITION1}){
			goto LINE;
		}
	}
	
	for ($POSITION2=($POS2-$INTERVAL) ; $POSITION2<=($POS2+$INTERVAL) ; $POSITION2+=100){
		if (exists $FPlist{$CHRM}{$POSITION2}){
			goto LINE;
		}
	}
	
	print FILE_print "$_\n";
}
close FILE_CClist;

close FILE_print;