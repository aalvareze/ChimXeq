open FILE_print, ">$ARGV[2]";	# $ARGV[2] = ../Output_non-reiterFUSIONS.txt

open FILE1, "<$ARGV[0]";	# $ARGV[0] = ../Output_reiterGENES.txt
while (<FILE1>){
	chomp;
	@LINE=split(/\t/,$_);
	$NAME=$LINE[0];
	
	$HASH1{$NAME}=1;
}
close FILE1;

open FILE2, "<$ARGV[1]";	# $ARGV[1] = ../Output_LISTofFUSIONGENES.txt
while (<FILE2>){
	chomp;
	# @CHIMERA=split(/-/,$_);
	# $NAME1=substr($CHIMERA[0],0,-1);
	# $NAME2=substr($CHIMERA[1],1);
	$CHIMERA=split(/ - /,$_);
	$NAME1=$CHIMERA[0];
	$NAME2=$CHIMERA[1];
	
	if ((exists $HASH1{$NAME1}) || exists ($HASH1{$NAME2})){
		goto END;
	}
	
	if (exists $FUSION{$NAME1}{$NAME2}){
		$COUNT=$FUSION{$NAME1}{$NAME2}[0]+1;
		$FUSION{$NAME1}{$NAME2}[0]=$COUNT;
		goto END;
	}
	
	if (exists $FUSION{$NAME2}{$NAME1}){
		$COUNT=$FUSION{$NAME2}{$NAME1}[0]+1;
		$FUSION{$NAME2}{$NAME1}[0]=$COUNT;
		goto END;
	}
	
	$COUNT=1;
	$FUSION{$NAME1}{$NAME2}[0]=$COUNT;
	
	END:
}
close FILE2;

foreach $KEY_NAME1 (sort {$a<=>$b} keys %FUSION){
	foreach $KEY_NAME2 (sort {$a<=>$b} keys %{$FUSION{$KEY_NAME1}}){
		$COUNT_prima=$FUSION{$KEY_NAME1}{$KEY_NAME2}[0];
		print FILE_print "$KEY_NAME1 - $KEY_NAME2\t$COUNT_prima\n";
	}
}	
	
close FILE_print;