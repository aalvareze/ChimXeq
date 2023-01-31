open FILE_print, ">$ARGV[1]"; # $ARGV[1] = ../anchors.list

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../anchors.map
while (<FILE>){
	chomp;
	@LINE = split(/\t/,$_);
	@ID_pre = split(/\_/,$LINE[0]);
	$ID = $ID_pre[0];
	$CHR = $LINE[2];
	$POS = $LINE[3];
	$SEQ = $LINE[9];
	
	if ($CHR == chr && (($POS >= start1 && $POS <= end1) || ($POS >= start2 && $POS <= end2))){	# Coordinates for Gene1 and Gene2, respectively
		foreach $KEY_POS (sort {$a<=>$b} keys %{$CHECK{$ID}}){
			$DIF = $KEY_POS-$POS;
			if (abs($DIF) > 50000){
				$CHR_REC = $CHECK{$ID}{$KEY_POS}[0];
				$SEQ_REC = $CHECK{$ID}{$KEY_POS}[1];
				print FILE_print "$ID\t$CHR_REC\t$KEY_POS\t$SEQ_REC\t$CHR\t$POS\t$SEQ\n";
				
				goto END;
			}
		}
		$CHECK{$ID}{$POS}[0] = $CHR;
		$CHECK{$ID}{$POS}[1] = $SEQ;
		
		END:
	}
	
}
close FILE;

close FILE_print;
