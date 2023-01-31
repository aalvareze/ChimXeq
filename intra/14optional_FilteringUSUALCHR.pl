# This script was developed to remove all reads which align with sequences from unusual CHRs 

open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_FilteringUSUALCHR.txt

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_FilteringDUPLICATES_2.txt
while (<FILE>){
	chomp;
	@READ=split(/\s+/,$_);
	$CHR=$READ[2];	# $CHR = $CHR1 = $READ[2] = $READ[6] = $CHR2
	
	if ($CHR!~/_/ && $CHR ne "M"){
		print FILE_print "$_\n";
	}
}
close FILE;

close FILE_print;