open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_READSOUTofMERES.txt

open FILE_DB, "<$ARGV[0]";	# $ARGV[0] = ../Positions_MERES.txt
while (<FILE_DB>){
	chomp;
	@DB=split(/\t/,$_);
	$CHR_DB=$DB[0];
	$POS1_DB=$DB[1];
	$POS2_DB=$DB[2];

	$HashDB{$CHR_DB}{$POS1_DB}[0]=$POS2_DB;

}
close FILE_DB;

open FILE_LD, "<$ARGV[1]";		# $ARGV[1] = ../Output_FilteringDUPLICATES_1.txt
while (<FILE_LD>){
	chomp;
	@LD=split(/\t/,$_);
	$CHR1_LD=$LD[2];
	$CHR1_LD=~s/chr//;
	$POS1_LD=$LD[3];
	$CHR2_LD=$LD[6];
	$CHR2_LD=~s/chr//;
	$POS2_LD=$LD[7];
	
	foreach $POS1(sort keys %{$HashDB{$CHR1_LD}}){
		$POS2=$HashDB{$CHR1_LD}{$POS1}[0];
		if ($POS1<=$POS1_LD && $POS1_LD<=$POS2){
			goto END;
		}
	}
	foreach $POS1(sort keys %{$HashDB{$CHR2_LD}}){
		$POS2=$HashDB{$CHR2_LD}{$POS1}[0];
		if ($POS1<=$POS2_LD && $POS2_LD<=$POS2){
			goto END;
		}
	}
	print FILE_print "$_\n";
	
	END:
}
close FILE_LD;

close FILE_print;