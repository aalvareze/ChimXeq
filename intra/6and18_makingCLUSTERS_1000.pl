open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_CLUSTERS_1.txt;Output_CLUSTERS_2.txt

$INTERVAL=1000;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_PAIREDREADS_1.txt;Output_PAIREDREADS_2.txt
while (<FILE>){
	chomp;
	@DATA=split(/\s+/,$_);
	
	$CHRM=$DATA[2];	# $CHRM = $CHRA = $DATA[2] = $DATA[6] = $CHRB
	$CHRM=~s/chr//;
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSA VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSA=$DATA[3];
	$DIVA=$prePOSA/1000;
	# $POSA_ROUND=int($DIVA);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSA_ROUND=sprintf("%.1f", $DIVA);
	$POSA=$POSA_ROUND*1000;
	# STRATEGY TO ROUND THE VALUE OF THE $prePOSB VARIABLE TO THE APPROXIMATE HUNDRED
	$prePOSB=$DATA[7];
	$DIVB=$prePOSB/1000;
	# $POSB_ROUND=int($DIVB);       # The "int()" command always rounds down, so its utility to make clusters is limited
	$POSB_ROUND=sprintf("%.1f", $DIVB);
	$POSB=$POSB_ROUND*1000;
	
	# FORWARD SENSE (POSITION1=$POSA && POSITION2=$POSB):
	for ($POSITION1=($POSA-$INTERVAL) ; $POSITION1<=($POSA+$INTERVAL) ; $POSITION1+=100){	# CLUSTERING IN THE REGION A?
		for ($POSITION2=($POSB-$INTERVAL) ; $POSITION2<=($POSB+$INTERVAL) ; $POSITION2+=100){	# CLUSTERING IN THE REGION B?
			if (exists $CLUSTER{$CHRM}{$POSITION1}{$POSITION2}){
				goto END;
			}
		}
	}
	# REVERSE SENSE ($POSITION1=$POSB && $POSITION2=$POSA):
	for ($POSITION1=($POSB-$INTERVAL) ; $POSITION1<=($POSB+$INTERVAL) ; $POSITION1+=100){	# CLUSTERING IN THE REGION A?
		for ($POSITION2=($POSA-$INTERVAL) ; $POSITION2<=($POSA+$INTERVAL) ; $POSITION2+=100){	# CLUSTERING IN THE REGION B?
			if (exists $CLUSTER{$CHRM}{$POSITION1}{$POSITION2}){
				goto END;
			}
		}
	}
	$CLUSTER{$CHRM}{$POSA}{$POSB}=1;
	END:
}
close FILE;

# PRINTING "CHR\tPOSA\tCHR\tPOSB\n"
foreach $KEY_CHRM (sort keys %CLUSTER){
	foreach $KEY_POSA (sort keys %{$CLUSTER{$KEY_CHRM}}){
		foreach $KEY_POSB (sort keys %{$CLUSTER{$KEY_CHRM}{$KEY_POSA}}){
			print FILE_print "$KEY_CHRM\t$KEY_POSA\t$KEY_CHRM\t$KEY_POSB\n";
		}
	}
}

close FILE_print;