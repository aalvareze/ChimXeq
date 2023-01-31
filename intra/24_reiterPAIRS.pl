# This script was developed to print clutering pairs (CHR-POS) associated with at least two different pairs (CHR-POS'). Duplicates are possible because PAIR1 (CHR-POS1) and PAIR2 (CHR-POS2) are processed separately

open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_reiterPAIRS.txt 

$INTERVAL=200;
open FILE_CClist, "<$ARGV[0]";  # $ARGV[0] = ../Output_readCLUSTERING_4_minN.txt
while(<FILE_CClist>){
	chomp;
	@CLUSTER=split(/\s+/,$_);
	$CHR=$CLUSTER[0];	# $CHR = $CHR1 = $CLUSTER[0] = $CLUSTER[2] = $CHR2
	$POS1=$CLUSTER[1];
	$POS2=$CLUSTER[3];
	
	for ($POSITION1=($POS1-$INTERVAL) ; $POSITION1<=($POS1+$INTERVAL) ; $POSITION1+=100){
		if (exists $CLUSTER1{$CHR}{$POSITION1}){
			$POS2_prima=$CLUSTER1{$CHR}{$POSITION1}[0];
			if (($POS2_prima>=($POS2+200000)) || (($POS2-200000)>=$POS2_prima)){
				$FPlist{$CHR}{$POS2_prima}{$POS2}=1;
			}
		}
		$CLUSTER1{$CHR}{$POSITION1}[0]=$POS2;
	}
	
	for ($POSITION2=($POS2-$INTERVAL) ; $POSITION2<=($POS2+$INTERVAL) ; $POSITION2+=100){
		if (exists $CLUSTER2{$CHR}{$POSITION2}){
			$POS1_prima=$CLUSTER2{$CHR}{$POSITION2}[0];
			if (($POS1_prima>=($POS1+200000)) || (($POS1-200000)>=$POS1_prima)){
				$FPlist{$CHR}{$POS1_prima}{$POS1}=1;
			}
		}
		$CLUSTER2{$CHR}{$POSITION2}[0]=$POS1;
	}
}
close FILE_CClist;

print FILE_print "CHR\tPOS\n";
foreach $KEY_CHR (sort {$a<=>$b} keys %FPlist){
	foreach $KEY_POS_prima (sort {$a<=>$b} keys %{$FPlist{$KEY_CHR}}){
		foreach $KEY_POS (sort {$a<=>$b} keys %{$FPlist{$KEY_CHR}{$KEY_POS_prima}}){
			if ($KEY_POS_prima==$KEY_POS){
				print FILE_print "$KEY_CHR\t$KEY_POS_prima\n";
			}
			else{
				print FILE_print "$KEY_CHR\t$KEY_POS_prima\n";
				print FILE_print "$KEY_CHR\t$KEY_POS\n";
			}
		}
	}
}

close FILE_print;