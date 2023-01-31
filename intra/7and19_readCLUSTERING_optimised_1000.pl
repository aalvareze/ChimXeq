# The following script was designed to store each read wherever possible. The output may enclose duplicates because of specific reads are stored in different clusters 

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_readCLUSTERING_1.txt;Output_readCLUSTERING_2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../Output_CLUSTERS_1.txt;Output_CLUSTERS_2.txt
while (<FILE1>){
	chomp;
	@DATA=split(/\s+/,$_);
	$CHR=$DATA[0];	# $CHR = $CHR1 = $CHR2
	$CHR=~s/chr//;
	$POS1=$DATA[1];	# Rounding the POS1 is not necessary because that was made previously by "makingCLUSTERS.pl"
	$POS2=$DATA[3];	# Rounding the POS2 is not necessary because that was made previously by "makingCLUSTERS.pl"
	
	$CLUSTER{$CHR}{$POS1}{$POS2}[0]=0;	# TOTAL SUPPORTIVE READS (TSR)
	$CLUSTER{$CHR}{$POS1}{$POS2}[1]=0;  # FORWARD READS SUPPORTING CLUSTERING IN A AND B (fwdSR)
	$CLUSTER{$CHR}{$POS1}{$POS2}[2]=0;  # REVERSE READS SUPPORTING CLUSTERING IN A AND B (rvSR)
}
close FILE1;

$INTERVAL=1000;
open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../Output_PAIREDREADS_1.txt;Output_PAIREDREADS_2.txt
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
				$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[0]=$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[0]+1;
				$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[1]=$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[1]+1;
			}
		}
	}
	foreach $KEY_POS1 (sort keys %{$CLUSTER{$CHR}}){			
		foreach $KEY_POS2 (sort keys %{$CLUSTER{$CHR}{$KEY_POS1}}){			
			if (($KEY_POS1-$INTERVAL)<=$POSB && $POSB<=($KEY_POS1+$INTERVAL) && ($KEY_POS2-$INTERVAL)<=$POSA && $POSA<=($KEY_POS2+$INTERVAL)){
				$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[0]=$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[0]+1;
				$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[2]=$CLUSTER{$CHR}{$KEY_POS1}{$KEY_POS2}[2]+1;
			}
		}
	}

}
close FILE2;

foreach $KEY2_CHR (sort keys %CLUSTER){
	foreach $KEY2_POS1 (sort keys %{$CLUSTER{$KEY2_CHR}}){
		foreach $KEY2_POS2 (sort keys %{$CLUSTER{$KEY2_CHR}{$KEY2_POS1}}){
			$TSR_prima=$CLUSTER{$KEY2_CHR}{$KEY2_POS1}{$KEY2_POS2}[0];
			$fwdSR_prima=$CLUSTER{$KEY2_CHR}{$KEY2_POS1}{$KEY2_POS2}[1];
			$rvSR_prima=$CLUSTER{$KEY2_CHR}{$KEY2_POS1}{$KEY2_POS2}[2];
			print FILE_print "$KEY2_CHR\t$KEY2_POS1\t$KEY2_CHR\t$KEY2_POS2\t$TSR_prima\t$fwdSR_prima\t$rvSR_prima\n";
		}
	}
}

close FILE_print;