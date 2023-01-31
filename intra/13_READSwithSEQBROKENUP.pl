open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_READSwithSEQBROKENUP.txt

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_FilteringDUPLICATES_2.txt
while (<FILE>){
	chomp;
	@READ=split(/\s+/,$_);
	
	for $posSEQn(11..$#READ){
		if (($READ[$posSEQn]!~/\W/) && ($READ[$posSEQn]!~/\d/)){
			print FILE_print "$_\n";
			goto END;
		}
	}
	
	END:
}
close FILE;

close FILE_print;