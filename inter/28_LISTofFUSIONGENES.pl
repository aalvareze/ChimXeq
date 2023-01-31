open FILE_print, ">$ARGV[2]";	# $ARGV[2] = Output_LISTofFUSIONGENES.txt

open FILE_callingGENES, "<$ARGV[0]";	# $ARGV[0] = ../callingGENES2.txt
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
	$CHR1=$CLUSTER[0];
	$POS1=$CLUSTER[1];
	$CHR2=$CLUSTER[2];
	$POS2=$CLUSTER[3];
	
	foreach $KEY_START (sort {$a<=>$b} keys %{$GENE{$CHR1}}){
		foreach $KEY_END (sort {$a<=>$b} keys %{$GENE{$CHR1}{$KEY_START}}){
			$NAME_prima1=$GENE{$CHR1}{$KEY_START}{$KEY_END}[0];
			if ($KEY_START<=($POS1-$INTERVAL) && ($POS1+$INTERVAL)<=$KEY_END){
				print FILE_print "$NAME_prima1 - ";
				goto END;
			}
		}
	}
	print FILE_print "NaN - ";
	
	END:
	
	foreach $KEY2_START (sort {$a<=>$b} keys %{$GENE{$CHR2}}){
		foreach $KEY2_END (sort {$a<=>$b} keys %{$GENE{$CHR2}{$KEY2_START}}){
			$NAME_prima2=$GENE{$CHR2}{$KEY2_START}{$KEY2_END}[0];
			if ($KEY2_START<=($POS2-$INTERVAL) && ($POS2+$INTERVAL)<=$KEY2_END){
				print FILE_print "$NAME_prima2\n";
				goto LINE;
			}
		}
	}
	print FILE_print "NaN\n";
}
close FILE_CClist;

close FILE_print;