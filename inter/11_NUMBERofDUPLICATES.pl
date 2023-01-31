open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_NUMBERofDUPLICATES_1.txt

$COUNT=0;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_FilteringSUPREADS_1.txt
while (<FILE>){
	chomp;
	@DATA=split(/\s+/,$_);
	$CHRA=$DATA[2];
	$CHRA=~s/chr//;
	$POSA=$DATA[3];
	$CHRB=$DATA[6];
	$CHRB=~s/chr//;
	$POSB=$DATA[7];
	
	if (exists $READ{$CHRA}{$POSA}{$CHRB}{$POSB}){
		$COUNT++;
	}
	else{
		$READ{$CHRA}{$POSA}{$CHRB}{$POSB}=1;
	}
}
close FILE;

print FILE_print "$COUNT\n";

close FILE_print;