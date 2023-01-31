# Script designed to print the IDs which have associated 2 reads. One of them will be FWD whereas the other one will be RV because possible duplicates were removed previously with "FilteringDUPLICATES.pl"
	# Output values for $COUNT: 1 (single reads) and 2 (paired reads)
	
open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../Output_IDsPAIREDREADS_1.txt;Output_IDsPAIREDREADS_2.txt

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../Output_READSOUTofMERES.txt;Output_POLYFILTER.txt
while (<FILE>){
	chomp;
	@READ=split(/\s+/,$_);
	
	$ID=$READ[0];
	if (substr($ID,-2) eq ':1' || substr($ID,-2) eq ':2'){	# Command to remove the characters ":n" (n = 1/2) from IDs when they are used to distinguish paired reads 
		$ID=substr($ID,0,-2);
	}
	
	if (exists $DATA{$ID}){
		$DATA{$ID}[0]=$DATA{$ID}[0]+1;
		goto END;
	}

	$DATA{$ID}[0]=1;

	END:
}
close FILE;

# Print "$ID\n", when $COUNT=2
foreach $KEY_ID (sort keys %DATA){
	$COUNT=$DATA{$KEY_ID}[0];
	if ($COUNT==2){
		print FILE_print "$KEY_ID\n";
	}
}

close FILE_print;