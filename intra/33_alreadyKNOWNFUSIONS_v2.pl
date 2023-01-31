open FILE_PRINT, ">$ARGV[2]";	# $ARGV[2] = ../Output_alreadyKNOWNFUSIONS_v2.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../GeneFusionDB.txt
while (<FILE1>){
	chomp;
	
	@LINE1 = split(/\t/,$_);
	$NAME1 = $LINE1[0];
	$NAME2 = $LINE1[1];
	
	$HASH{$NAME1}{$NAME2} = 1;
}
close FILE1;

open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../Output_LISTofFUSIONGENES_supportingREADS_v2.txt
while (<FILE2>){
	chomp;

	@LINE2 = split(/\t/,$_);
	$SYMBOL1 = $LINE2[2];
	$SYMBOL2 = $LINE2[5];
	
	if ((exists $HASH{$SYMBOL1}{$SYMBOL2}) || (exists $HASH{$SYMBOL2}{$SYMBOL1})){
		print FILE_PRINT "$_\tAlready_Known_Fusion\n";
	}
	else{
		print FILE_PRINT "$_\n";
	}
}
close FILE2;

close FILE_PRINT;