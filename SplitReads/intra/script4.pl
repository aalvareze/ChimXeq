open FILE_print, ">$ARGV[1]";	# $ARGV[1] = ../candidates.uniq.list

open FILE, "<$ARGV[0]";	# $ARGV[0] = ../candidates.list
while (<FILE>){
	chomp;
	
	@LINE = split(/\t/,$_);
	$ID = $LINE[0];
	$SEQ = $LINE[1];
	
	if ((exists $HASH1{$ID}{$SEQ}) || (exists $HASH2{$SEQ})){
		next;
	}
	else{
		$HASH1{$ID}{$SEQ} = 1;
		$HASH2{$SEQ} = 1;
		
		print FILE_print "$_\n";
	}
}
close FILE;

close FILE_print;
