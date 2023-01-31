# Código que tiene por objeto imprimir todas las lecturas almacenadas en clusters con >= 3 lecturas apoyando la clusterización en A y B

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_FilteringSUPREADS_1.txt;Output_FilteringSUPREADS_2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../Output_readCLUSTERING_1_minN.txt;Output_readCLUSTERING_CANDIDATElist.txt
while (<FILE1>){
	chomp;
	@DATA=split(/\s+/,$_);
	$CHR=$DATA[0];	# $CHR = $CHR1 = $CHR2
	$CHR=~s/chr//;
	$POS1=$DATA[1];
	$POS2=$DATA[3];
	
	$CLUSTER{$CHR}{$POS1}{$POS2}=1;
}
close FILE1;

$INTERVAL=1000;
open FILE2, "<$ARGV[1]";	# $ARGV[1] = Output_PAIREDREADS_1.txt;Output_PAIREDREADS_2.txt
while (<FILE2>){
	chomp;
	@READ=split(/\s+/,$_);
	
	$CHR=$READ[2];	# $CHR = $CHRA = $CHRB
	$CHR=~s/chr//;
	
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSA VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSA=$READ[3];
	$DIVA=$prePOSA/1000;
	# $POSA_ROUND=int($DIVA);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSA_ROUND=sprintf("%.1f", $DIVA);
	$POSA=$POSA_ROUND*1000;
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSB VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSB=$READ[7];
	$DIVB=$prePOSB/1000;
	# $POSB_ROUND=int($DIVB);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSB_ROUND=sprintf("%.1f", $DIVB);
	$POSB=$POSB_ROUND*1000;
	

	foreach $KEY_POS1 (sort keys %{$CLUSTER{$CHR}}){
		foreach $KEY_POS2 (sort keys %{$CLUSTER{$CHR}{$KEY_POS1}}){
			if (($KEY_POS1-$INTERVAL)<=$POSA && $POSA<=($KEY_POS1+$INTERVAL) && ($KEY_POS2-$INTERVAL)<=$POSB && $POSB<=($KEY_POS2+$INTERVAL)){
				print FILE_print "$_\n";
			}
		}
	}
	foreach $KEY_POS1 (sort keys %{$CLUSTER{$CHR}}){
		foreach $KEY_POS2 (sort keys %{$CLUSTER{$CHR}{$KEY_POS1}}){
			if (($KEY_POS1-$INTERVAL)<=$POSB && $POSB<=($KEY_POS1+$INTERVAL) && ($KEY_POS2-$INTERVAL)<=$POSA && $POSA<=($KEY_POS2+$INTERVAL)){
				print FILE_print "$_\n";
			}
		}
	}
}
close FILE2;

close FILE_print;