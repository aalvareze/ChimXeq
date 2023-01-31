open FILE_PRINT, ">$ARGV[2]";	# $ARGV[2] = ../Output_CANCERGENEinvolved_v2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../cosmic.txt
while (<FILE1>){
	chomp;
	
	@LINE1 = split(/\t/,$_);
	$NAME = $LINE1[0];
	
	$HASH{$NAME} = 1;
}
close FILE1;

open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../Output_alreadyKNOWNFUSIONS_v2.txt
while (<FILE2>){
	chomp;
	
	@LINE2 = split(/\t/,$_);
	$SYMBOL1 = $LINE2[2];
	$SYMBOL2 = $LINE2[5];
	
	if ((exists $HASH{$SYMBOL1}) || (exists $HASH{$SYMBOL2})){
		if ($_ =~ /Already_Known_Fusion/){
			print FILE_PRINT "$_;Cancer_Gene_Involved\n";
		}
		else{
			print FILE_PRINT "$_\tCancer_Gene_Involved\n";
		}
	}
	else{
		print FILE_PRINT "$_\n";
	}
}
close FILE2;

close FILE_PRINT;