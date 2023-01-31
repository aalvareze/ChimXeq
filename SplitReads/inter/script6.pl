# NOTE: Genes labeled may finally differ regarding the genes obtained after processing discordant reads because of coordenates 

open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../candidates.uniq.coord.list

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../callingGENES.txt
while (<FILE1>){
	chomp;
	
	@LINE1 = split(/\t/,$_);
	$CHR = $LINE1[0];
	$POS_left = $LINE1[1];
	$POS_right = $LINE1[2];
	$NAME = $LINE1[3];
	
	$HASH1{$CHR}{$POS_left}{$POS_right}[0] = $NAME;
}
close FILE1;

$COUNT = 1;
open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../candidates.uniq.sam
while (<FILE2>){
	chomp;
	
	if ($COUNT <= 5){
		$COUNT = $COUNT + 1;
		next;
	}
	
	@LINE2 = split(/\t/,$_);
	$ID = $LINE2[9];
	$CHR = $LINE2[13];
	
	if (exists $HASH2{$ID}){
		if ($HASH2{$ID}[0] == chr1 && $CHR == chr2){
			print FILE_print "$_\n";
		}
	}
	if (exists $HASH2{$ID}){
		if ($HASH2{$ID}[0] == 2 && $CHR == 1){
			print FILE_print "$_\n";
		}
	}
	if ($CHR == chr1){
		$HASH2{$ID}[0] = 1;
	}
	if ($CHR == chr2){
		$HASH2{$ID}[0] = 2;
	}
	#chop($LINE2[18]);
	#@SIZE = split(/,/,$LINE2[18]);
	#chop($LINE2[20]);
	#@POS = split(/,/,$LINE2[20]);
	#if ($#POS == 1){
		$POS1 = $POS[0] + $SIZE[0];
		$POS2 = $POS[1] + 1;
		
		$NAME1 = 0;
		$NAME2 = 0;
		foreach $KEY_CHR (sort {$a <=> $b} keys %HASH1){
			foreach $KEY_POS1 (sort {$a <=> $b} keys %{$HASH1{$KEY_CHR}}){
				foreach $KEY_POS2 (sort {$a <=> $b} keys %{$HASH1{$KEY_CHR}{$KEY_POS1}}){
					if ($KEY_CHR == $CHR && $KEY_POS1 <= $POS1 && $POS1 <= $KEY_POS2){
						$NAME1 = $HASH1{$KEY_CHR}{$KEY_POS1}{$KEY_POS2}[0];
					}
					if ($KEY_CHR == $CHR && $KEY_POS1 <= $POS2 && $POS2 <= $KEY_POS2){
						$NAME2 = $HASH1{$KEY_CHR}{$KEY_POS1}{$KEY_POS2}[0];
					}
				}
			}
		}
		if ($NAME1 eq 0){
			$NAME1 = "NaN";
		}
		if ($NAME2 eq 0){
			$NAME2 = "NaN";
		}
		
		#print FILE_print "$NAME1\t$CHR\t$POS1\t$NAME2\t$CHR\t$POS2\n";
	#}
}
close FILE2;

close FILE_print;
