open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_LISTofFUSIONGENES_supportingREADS_v2.txt

open FILE_callingGENES, "<$ARGV[0]";	# $ARGV[0] = ../callingGENES.txt
while (<FILE_callingGENES>){
	chomp;
	@PARAMETERS=split(/\t/,$_);
	$CHR=$PARAMETERS[0];
	$START=$PARAMETERS[1];
	$END=$PARAMETERS[2];
	$NAME=$PARAMETERS[3];
	
	$GENE{$CHR}{$START}{$END}[0]=$NAME;
}
close FILE_callingGENES;

$INTERVAL=200;
open FILE_CClist, "<$ARGV[1]";	# $ARGV[1] = ../Output_readCLUSTERING_CANDIDATElist.txt
LINE:
while (<FILE_CClist>){
	chomp;
	@CLUSTER=split(/\t/,$_);
	$CHR=$CLUSTER[0];
	$POS1=$CLUSTER[1];
	$POS2=$CLUSTER[3];
	
	foreach $KEY_START (sort {$a<=>$b} keys %{$GENE{$CHR}}){
		foreach $KEY_END (sort {$a<=>$b} keys %{$GENE{$CHR}{$KEY_START}}){
			$NAME_prima1=$GENE{$CHR}{$KEY_START}{$KEY_END}[0];
			if ($KEY_START<=($POS1-$INTERVAL) && ($POS1+$INTERVAL)<=$KEY_END){
				print FILE_print "$CHR\t$POS1\t$NAME_prima1\t";
				goto END;
			}
		}
	}
	print FILE_print "$CHR\t$POS1\tNaN\t";
	
	END:
	
	foreach $KEY2_START (sort {$a<=>$b} keys %{$GENE{$CHR}}){
		foreach $KEY2_END (sort {$a<=>$b} keys %{$GENE{$CHR}{$KEY2_START}}){
			$NAME_prima2=$GENE{$CHR}{$KEY2_START}{$KEY2_END}[0];
			if ($KEY2_START<=($POS2-$INTERVAL) && ($POS2+$INTERVAL)<=$KEY2_END){
				print FILE_print "$CHR\t$POS2\t$NAME_prima2\t";
				for $A(4..$#CLUSTER){
					if ($A<$#CLUSTER){
						print FILE_print "$CLUSTER[$A]\t";
					}
					else{
						print FILE_print "$CLUSTER[$A]\n";
					}
				}
				goto LINE;
			}
		}
	}
	print FILE_print "$CHR\t$POS2\tNaN\t";
	for $A(4..$#CLUSTER){	
		if ($A<$#CLUSTER){
			print FILE_print "$CLUSTER[$A]\t";
		}
		else{
			print FILE_print "$CLUSTER[$A]\n";
		}
	}
}
close FILE_CClist;

close FILE_print;