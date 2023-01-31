open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_NUMBERofDUPLICATES_1.txt

$COUNT=0;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_FilteringSUPREADS_1.txt
while (<FILE>){
	chomp;
	@DATA=split(/\s+/,$_);
	$CHRM=$DATA[2];	# $CHRM = $CHRA = $DATA[2] = $DATA[6] = $CHRB
	$CHRM=~s/chr//;
	$POSA=$DATA[3];
	$POSB=$DATA[7];
	
	if (exists $READ{$CHRM}{$POSA}{$POSB}){
		$COUNT++;
		goto END;
	}
	$READ{$CHRM}{$POSA}{$POSB}=1;
	
	END:
}
close FILE;

print FILE_print "$COUNT\n";

close FILE_print;