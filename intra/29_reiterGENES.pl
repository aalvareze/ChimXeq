open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_reiterGENES.txt

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_LISTofFUSIONGENES.txt
while (<FILE>){
	chomp;
	#@FUSION=split(/-/,$_);
	#$NAME1=substr($FUSION[0],0,-1);
	#$NAME2=substr($FUSION[1],1);
	$FUSION=split(/ - /,$_);
	$NAME1=$FUSION[0];
	$NAME2=$FUSION[1];
	
	if (exists $HASH{$NAME1}){
		$NAME_prima=$HASH{$NAME1}[0];
		if ($NAME_prima ne $NAME2){
			$FP{$NAME1}=1;
		}
	}
	
	if (exists $HASH{$NAME2}){
		$NAME_prima=$HASH{$NAME2}[0];
		if ($NAME_prima ne $NAME1){
			$FP{$NAME2}=1;
		}
	}
	
	$HASH{$NAME1}[0]=$NAME2;
	$HASH{$NAME2}[0]=$NAME1;
}
close FILE;

foreach $KEY_NAME (sort {$a<=>$b} keys %FP){
	print FILE_print "$KEY_NAME\n";
}

close FILE_print;