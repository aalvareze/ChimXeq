# Filtro de posibles replicas en base a las POS1 y POS2 asi como al CHR correspondiente 

open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_FilteringDUPLICATES_1.txt;Output_FilteringDUPLICATES_2.txt

open FILE, "<$ARGV[0]";		# $ARGV[0] = ../Output_CHIMERICreads.sam;Output_FilteringSUPREADS_1.txt
LINE:
while (<FILE>){
	chomp;
	@PARAMETERS=split(/\s+/,$_);
	$CHR1=$PARAMETERS[2];
	$CHR1=~s/chr//;
	$POS1=$PARAMETERS[3];
	$CHR2=$PARAMETERS[6];
	$CHR2=~s/chr//;
	$POS2=$PARAMETERS[7];
	
	if (exists $READ{$CHR1}{$POS1}{$CHR2}{$POS2}){	# EN CASO DE ALMACENAR LA INFORMACION EN UN %HASH CON LA FORMA $DATA{$POS1}{$POS2}, SE ASUMIRIA QUE: Si $POS1readA==$POS1readB && $POS2readA==$POS2readB > necesariamente, $CHR1readA==$CHR1readB && $CHR2readA==$CHR2readB > NO SIEMPRE TIENE POR QUE SER CIERTO
		goto LINE;
	}
	
	$READ{$CHR1}{$POS1}{$CHR2}{$POS2}=1;
	
	for $A(0..1){
		print FILE_print "$PARAMETERS[$A]\t";
	}
	print FILE_print "$CHR1\t";
	for $B(3..5){
		print FILE_print "$PARAMETERS[$B]\t";
	}
	print FILE_print "$CHR2\t";
	for $C(7..$#PARAMETERS){
		if ($C<$#PARAMETERS){
			print FILE_print "$PARAMETERS[$C]\t";
		}
		else{
			print FILE_print "$PARAMETERS[$C]\n";
		}
	}

}
close FILE;
	
close FILE_print;