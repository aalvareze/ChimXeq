open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../candidates.list

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../anchors.list
while (<FILE1>){
	chomp;
	
	@LINE1 = split(/\t/,$_);
	$ID1 = $LINE1[0];
	$SEQ1 = $LINE1[3];
	$SEQ2 = $LINE1[6];
	
	$HASH{$ID1}{$SEQ1}{$SEQ2} = 1;
}
close FILE1;

open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../hits.sam
while (<FILE2>){
	chomp;
	
	if ($_ =~ /^@/){
		next;
	}
	
	@LINE2 = split(/\t/,$_);
	$ID2 = $LINE2[0];
	$SEQ = $LINE2[9];
	
	foreach $KEY_ID (sort {$a <=> $b} keys %HASH){
		foreach $KEY_SEQ1 (sort {$a <=> $b} keys %{$HASH{$KEY_ID}}){
			foreach $KEY_SEQ2 (sort {$a <=> $b} keys %{$HASH{$KEY_ID}{$KEY_SEQ1}}){
				if ($ID2 == $KEY_ID && $SEQ =~ /$KEY_SEQ1/ && $SEQ =~ /$KEY_SEQ2/){
					print FILE_print "$ID2\t$SEQ\n";
					
					goto END;
				}
			}
		}
	}
	END:
}
close FILE2;

close FILE_print;
