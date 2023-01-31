# The following script was designed to store each read wherever possible. The output may enclose duplicates because of specific reads are stored in different clusters 

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_readCLUSTERING_1.txt;Output_readCLUSTERING_2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../Output_CLUSTERS_1.txt;Output_CLUSTERS_2.txt
while (<FILE1>){
	chomp;
	@DATA=split(/\s+/,$_);
	$CHR1=$DATA[0];
	$CHR1=~s/chr//;
	$POS1=$DATA[1];	# Rounding the POS1 is not necessary because that was made previously by "makingCLUSTERS.pl"
	$CHR2=$DATA[2];
	$CHR2=~s/chr//;
	$POS2=$DATA[3];	# Rounding the POS2 is not necessary because that was made previously by "makingCLUSTERS.pl"
	
	$CLUSTER{$CHR1}{$POS1}{$CHR2}{$POS2}[0]=0;	# TOTAL SUPPORTIVE READS (TSR)
	$CLUSTER{$CHR1}{$POS1}{$CHR2}{$POS2}[1]=0;  # FORWARD READS SUPPORTING CLUSTERING IN A AND B (fwdSR)
	$CLUSTER{$CHR1}{$POS1}{$CHR2}{$POS2}[2]=0;  # REVERSE READS SUPPORTING CLUSTERING IN A AND B (rvSR)
}
close FILE1;

$INTERVAL=1000;
open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../Output_PAIREDREADS_1.txt;Output_PAIREDREADS_2.txt
while (<FILE2>){
	chomp;
	@READ=split(/\s+/,$_);
	
	$CHRA=$READ[2];
	$CHRA=~s/chr//;
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSA VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSA=$READ[3];
	$DIVA=$prePOSA/1000;
	# $POSA_ROUND=int($DIVA);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSA_ROUND=sprintf("%.1f", $DIVA);
	$POSA=$POSA_ROUND*1000;
	
	$CHRB=$READ[6];
	$CHRB=~s/chr//;
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSB VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSB=$READ[7];
	$DIVB=$prePOSB/1000;
	# $POSB_ROUND=int($DIVB);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSB_ROUND=sprintf("%.1f", $DIVB);
	$POSB=$POSB_ROUND*1000;
	
	foreach $KEY_POS1 (sort keys %{$CLUSTER{$CHRA}}){
		foreach $KEY_POS2 (sort keys %{$CLUSTER{$CHRA}{$KEY_POS1}{$CHRB}}){
			if (($KEY_POS1-$INTERVAL)<=$POSA && $POSA<=($KEY_POS1+$INTERVAL) && ($KEY_POS2-$INTERVAL)<=$POSB && $POSB<=($KEY_POS2+$INTERVAL)){
				$CLUSTER{$CHRA}{$KEY_POS1}{$CHRB}{$KEY_POS2}[0]=$CLUSTER{$CHRA}{$KEY_POS1}{$CHRB}{$KEY_POS2}[0]+1;
				$CLUSTER{$CHRA}{$KEY_POS1}{$CHRB}{$KEY_POS2}[1]=$CLUSTER{$CHRA}{$KEY_POS1}{$CHRB}{$KEY_POS2}[1]+1;
			}
		}
	}
	foreach $KEY_POS1 (sort keys %{$CLUSTER{$CHRB}}){			
		foreach $KEY_POS2 (sort keys %{$CLUSTER{$CHRB}{$KEY_POS1}{$CHRA}}){			
			if (($KEY_POS1-$INTERVAL)<=$POSB && $POSB<=($KEY_POS1+$INTERVAL) && ($KEY_POS2-$INTERVAL)<=$POSA && $POSA<=($KEY_POS2+$INTERVAL)){
				$CLUSTER{$CHRB}{$KEY_POS1}{$CHRA}{$KEY_POS2}[0]=$CLUSTER{$CHRB}{$KEY_POS1}{$CHRA}{$KEY_POS2}[0]+1;
				$CLUSTER{$CHRB}{$KEY_POS1}{$CHRA}{$KEY_POS2}[2]=$CLUSTER{$CHRB}{$KEY_POS1}{$CHRA}{$KEY_POS2}[2]+1;
			}
		}
	}
}
close FILE2;

foreach $KEY2_CHR1 (sort keys %CLUSTER){
	foreach $KEY2_POS1 (sort keys %{$CLUSTER{$KEY2_CHR1}}){
		foreach $KEY2_CHR2 (sort keys %{$CLUSTER{$KEY2_CHR1}{$KEY2_POS1}}){
			foreach $KEY2_POS2 (sort keys %{$CLUSTER{$KEY2_CHR1}{$KEY2_POS1}{$KEY2_CHR2}}){
				$TSR_prima=$CLUSTER{$KEY2_CHR1}{$KEY2_POS1}{$KEY2_CHR2}{$KEY2_POS2}[0];
				$fwdSR_prima=$CLUSTER{$KEY2_CHR1}{$KEY2_POS1}{$KEY2_CHR2}{$KEY2_POS2}[1];
				$rvSR_prima=$CLUSTER{$KEY2_CHR1}{$KEY2_POS1}{$KEY2_CHR2}{$KEY2_POS2}[2];
				print FILE_print "$KEY2_CHR1\t$KEY2_POS1\t$KEY2_CHR2\t$KEY2_POS2\t$TSR_prima\t$fwdSR_prima\t$rvSR_prima\n";
			}
		}
	}
}

close FILE_print;