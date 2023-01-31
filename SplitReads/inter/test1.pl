open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../test1.sam

$COUNT = 1;
open FILE, "<$ARGV[0]";	# $ARGV[0] = ../hits.sam
while (<FILE>){
	chomp;
	
	@LINE = split(/\t/,$_);
	$CHR = $LINE[2];
	#$START = $LINE[3];
	#chop($LINE[5]);
	#@POS = split(/[M,N]/,$LINE[5]);
	#$END = $START - 1;
	#for $A (0..$#POS){
	#	$END = $END + $POS[$A];
	#}
	#print FILE_print "$START\t$END\n";
	$POS = $LINE[3];
	if (($CHR == chr1 && $POS >= start1 && $POS <= end1) || ($CHR == chr2 && $POS >= start2 && $POS <= end2)){
		print FILE_print "$_\n";
	}
}
close FILE;
