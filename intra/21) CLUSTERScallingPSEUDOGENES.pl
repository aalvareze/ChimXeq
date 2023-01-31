open FILE_print, ">$ARGV[2]";	# $ARGV[2] = Output_readCLUSTERING_3.txt

open FILE_PGs, "<$ARGV[0]";	# $ARGV[0] = ../infoPSEUDOGENES.txt
while (<FILE_PGs>){
	chomp;
	@PG=split(/\s+/,$_);
	$CHRM=$PG[3];
	$START=$PG[4];
	$END=$PG[5];
	
	$H_PGs{$CHRM}{$START}{$END}=1;
}
close FILE_PGs;

$INTERVAL=200;
open FILE_rCaPF, "<$ARGV[1]";	# $ARGV[1] = ../Output_readCLUSTERING_2_minN.txt
while (<FILE_rCaPF>){
	chomp;
	@rCaPF=split(/\s+/,$_);
	$CHR=$rCaPF[0];	# $CHR = $CHR1 = $rCaPF[0] = $rCaPF[2] = $CHR2
	$CHR=~s/chr//;
	$POS1=$rCaPF[1];
	$POS2=$rCaPF[3];
	
	foreach $KEY_START (sort {$a<=>$b} keys %{$H_PGs{$CHR}}){
		foreach $KEY_END (sort {$a<=>$b} keys %{$H_PGs{$CHR}{$KEY_START}}){
			if (($KEY_START<=($POS1-$INTERVAL) && ($POS1+$INTERVAL)<=$KEY_END) || ($KEY_START<=($POS2-$INTERVAL) && ($POS2+$INTERVAL)<=$KEY_END)){
				print FILE_print "$_\tMATCHINGinPSEUDOGENE\n";
				goto END;
			}
		}
	}
	print FILE_print "$_\n";
	
	END:
}
close FILE_rCaPF;

close FILE_print;