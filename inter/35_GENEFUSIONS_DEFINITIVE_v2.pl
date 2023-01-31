open FILE_PRINT, ">$ARGV[1]";	# $ARGV[1] = ../Output_GENEFUSIONS_DEFINITIVE_v2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../Output_CANCERGENEinvolved_v2.txt
while (<FILE1>){
	chomp;
	
	@LINE1 = split(/\t/,$_);
	$CHR1 = $LINE1[0];
	$POS1 = $LINE1[1];
	$NAME1 = $LINE1[2];
	$CHR2 = $LINE1[3];
	$POS2 = $LINE1[4];
	$NAME2 = $LINE1[5];
	$TSR1 = $LINE1[6];	# Paired-End Sequencing
	
	if (exists $HASH{$NAME1}{$NAME2}){
		$TSR2 = $HASH{$NAME1}{$NAME2}[0] + $TSR1;
		$HASH{$NAME1}{$NAME2}[0] = $TSR2;	
	}
	else{
		$HASH{$NAME1}{$NAME2}[0] = $TSR1;
		$HASH{$NAME1}{$NAME2}[2] = $CHR1;
		$HASH{$NAME1}{$NAME2}[3] = $POS1;
		$HASH{$NAME1}{$NAME2}[4] = $CHR2;
		$HASH{$NAME1}{$NAME2}[5] = $POS2;
		if (($_ =~ /Already_Known_Fusion/) && ($_ !~ /Cancer_Gene_Involved/)){
			$TAG1 = "Already_Known_Fusion";
			$HASH{$NAME1}{$NAME2}[1] = $TAG1;
		}
		elsif (($_ !~ /Already_Known_Fusion/) && ($_ =~ /Cancer_Gene_Involved/)){
			$TAG2 = "Cancer_Gene_Involved";
			$HASH{$NAME1}{$NAME2}[1] = $TAG2;
		}
		elsif (($_ =~ /Already_Known_Fusion/) && ($_ =~ /Cancer_Gene_Involved/)){
			$TAG3 = "Already_Known_Fusion" . ";" . "Cancer_Gene_Involved";
			$HASH{$NAME1}{$NAME2}[1] = $TAG3;
		}
	}
}
close FILE1;

foreach $KEY_NAME1 (sort {$a <=> $b} keys %HASH){
	foreach $KEY_NAME2 (sort {$a <=> $b} keys %{$HASH{$KEY_NAME1}}){
		$TSR_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[0];
		$TSR_ONLY = $TSR_REC/2;
		
		$TAG_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[1];
		$CHR1_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[2];
		$POS1_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[3];
		$CHR2_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[4];
		$POS2_REC = $HASH{$KEY_NAME1}{$KEY_NAME2}[5];
		if (($TAG_REC =~ /Already_Known_Fusion/) && ($TAG_REC !~ /Cancer_Gene_Involved/)){
			print FILE_PRINT "$CHR1_REC\t$POS1_REC\t$KEY_NAME1\t$CHR2_REC\t$POS2_REC\t$KEY_NAME2\t$TSR_REC\t$TSR_ONLY\t$TSR_ONLY\t$TAG_REC\n";
		}
		elsif (($TAG_REC !~ /Already_Known_Fusion/) && ($TAG_REC =~ /Cancer_Gene_Involved/)){
			print FILE_PRINT "$CHR1_REC\t$POS1_REC\t$KEY_NAME1\t$CHR2_REC\t$POS2_REC\t$KEY_NAME2\t$TSR_REC\t$TSR_ONLY\t$TSR_ONLY\t$TAG_REC\n";
		}
		elsif (($TAG_REC =~ /Already_Known_Fusion/) && ($TAG_REC =~ /Cancer_Gene_Involved/)){
			print FILE_PRINT "$CHR1_REC\t$POS1_REC\t$KEY_NAME1\t$CHR2_REC\t$POS2_REC\t$KEY_NAME2\t$TSR_REC\t$TSR_ONLY\t$TSR_ONLY\t$TAG_REC\n";
		}
		elsif ($TSR_REC >= 6){
			print FILE_PRINT "$CHR1_REC\t$POS1_REC\t$KEY_NAME1\t$CHR2_REC\t$POS2_REC\t$KEY_NAME2\t$TSR_REC\t$TSR_ONLY\t$TSR_ONLY\n";
		}
	}
}

close FILE_PRINT;