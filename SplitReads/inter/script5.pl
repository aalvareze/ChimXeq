open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../candidates.uniq.fa

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../candidates.uniq.list
while (<FILE>){
	chomp;
	
	@LINE = split(/\t/,$_);
	$ID = $LINE[0];
	$SEQ = $LINE[1];
	
	print FILE_print ">$ID\n$SEQ\n";
}
close FILE;

close FILE_print;
