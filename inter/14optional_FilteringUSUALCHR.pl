# This script was developed to remove all reads which align with sequences from unusual CHRs 

open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_FilteringUSUALCHR.txt

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_FilteringDUPLICATES_2.txt
while (<FILE>){
	chomp;
	@READ=split(/\s+/,$_);
	$CHR1=$READ[2];
	$CHR2=$READ[6];
	
	if ($CHR1!~/_/ && $CHR1 ne "M" && $CHR2!~/_/ && $CHR2 ne "M"){
		print FILE_print "$_\n";
	}
}
close FILE;

close FILE_print;