open FILE, "<$ARGV[0]";	# $ARGV[0] = ../candidates.uniq.list
while (<FILE>){
	chomp;
	
	@LINE = split(/\t/,$_);
	$ID = $LINE[0];
	$SEQ = $LINE[1];
	
	qx{awk '\$1=="$ID" && \$10=="$SEQ"' ../hits.sam >> candidates.uniq.sam};
}
close FILE;