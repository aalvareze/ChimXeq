open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../anchors.fa

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../hits.sam
while (<FILE>){
	chomp;
	@LINE = split(/\t/,$_);
	$ID = $LINE[0];
	$SEQUENCE = $LINE[9];
	$SEQ_LEFT = substr($SEQUENCE,0,25);
	$SEQ_RIGHT = substr($SEQUENCE,76);
	
	#$ID_LEFT = "$ID" . "_left";
	#$ID_RIGHT = "$ID" . "_right";
	#print FILE_print ">$ID_LEFT\n$SEQ_LEFT\n>$ID_RIGHT\n$SEQ_RIGHT\n";
	print FILE_print ">$ID\n$SEQ_LEFT\n>$ID\n$SEQ_RIGHT\n";
}
close FILE;
	
close FILE_print;
