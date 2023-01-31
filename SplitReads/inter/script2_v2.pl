open FILE_print, ">$ARGV[1]"; # $ARGV[1] = ../anchors.list

$COUNT = 0;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../anchors.map
while (<FILE>){
	chomp;
	
	if ($_ =~ /^@/){
		next;
	}
	
	@LINE = split(/\t/,$_);
	$ID = $LINE[0];
	$CHR = $LINE[2];
	$POS = $LINE[3];
	$SEQ = $LINE[9];
	
	if ($COUNT > 0){
		foreach $KEY_ID (sort {$a <=> $b} keys %HASH){
			if ($KEY_ID eq $ID){
				foreach $KEY_CHR (sort {$a <=> $b} keys %{$HASH{$KEY_ID}}){
					if ($KEY_CHR == chr1){
						foreach $KEY_POS (sort {$a <=> $b} keys %{$HASH{$KEY_ID}{$KEY_CHR}}){
							if ($CHR == chr1 && $POS >= start1 && $POS <= end1){	# Coordinates for Gene1
								$SEQ_REC = $HASH{$KEY_ID}{$KEY_CHR}{$KEY_POS}[0];
								print FILE_print "$KEY_ID\t$KEY_CHR\t$KEY_POS\t$SEQ_REC\t$CHR\t$POS\t$SEQ\n";
							}
						}
					}
					if ($KEY_CHR == chr2){
						foreach $KEY_POS (sort {$a <=> $b} keys %{$HASH{$KEY_ID}{$KEY_CHR}}){
							if ($CHR == chr2 && $POS >= start2 && $POS <= end2){	# Coordinates for Gene2
								$SEQ_REC = $HASH{$KEY_ID}{$KEY_CHR}{$KEY_POS}[0];
								print FILE_print "$KEY_ID\t$CHR\t$POS\t$SEQ\t$KEY_CHR\t$KEY_POS\t$SEQ_REC\n";
							}
						}
					}
				}
			}
		}
	}
	if (($CHR == chr1 && $POS >= start1 && $POS <= end1) || ($CHR == chr2 && $POS >= start2 && $POS <= end2)){
		$HASH{$ID}{$CHR}{$POS}[0] = $SEQ;
		
		$COUNT = $COUNT + 1;
	}
}
close FILE;

close FILE_print;