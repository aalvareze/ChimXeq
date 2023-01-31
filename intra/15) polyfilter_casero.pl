$blat_command = 'gfClient -out=blast8 localhost $BLATPORT "" stdin stdout';
$blat_command2 = 'gfClient -out=blast8 localhost 9038 "" stdin stdout';
$OFFSET = 2;

sub blatscore{
	my $line = shift;
	my @t = split(/\s+/, $line);
	return $t[11];
}

LINE:
while (<>){
	chomp;
	$linea= $_;
	@fields = split (/\s+/, $_);
	if ($fields[1] =~ /VN:/ || $fields[1] =~ /SN:/ || $fields[1] =~ /ID:/){
		print "$linea\n";
		next LINE;
	}
	$chr = $fields[2];	# $chr = $fields[2] = $fields[6] = $chr_mate
	$genome_pos = $fields[3];
	$lectura = $fields[9];
	# $chr_mate = $fields[6];
	$genome_pos_mate = $fields[7];
	
	# BLAT filter
	my $comm = "echo \"\>tmp\n$lectura\" | $blat_command";
	my @brest = `$comm`;
	my @bres = sort {blatscore($b) <=> blatscore($a)} @brest;
	
	# Procesamos la primer entrada, que es la que tiene el score más alto del BLAT
	my $first = shift @bres;
	my @f1 = split(/\s+/, $first);
	
	# Contar many hits
	my $hits==0;
	foreach my $i (@bres){
		my @f2 = split(/\s+/, $i);
		if ($f2[2]>90){
			$hits++;
		}
		if ($hits>=10){
			next LINE;
		}
	}
	
	if (($f1[1] ne $chr ||
		($f1[8]>$genome_pos + $OFFSET && $f1[9]>$genome_pos + $OFFSET) ||
		($f1[8]<$genome_pos - $OFFSET && $f1[9]<$genome_pos - $OFFSET))
		|| ($f1[1] eq $chr && (abs($genome_pos_mate - $f1[8])<100000))){
			next LINE;
	}
	
	# Procesamos el resto de resultados del BLAT
	foreach my $i (@bres){
		my @f2 = split(/\s+/, $i);
		#print join("\t", @f1), "\n";
		if ($f2[2]>80 && $f2[1] eq $chr && (abs($genome_pos_mate - $f2[8])<100000)){
				next LINE;
		}
	}
# print "$linea\n";
#}
	
	# Segundo blat para localizar la lectura en hg38
	$numero = length($lectura);
	$chrom = $chr;	# $chrom = $chr = $chr_mate = $chrom_mate
	$start = $genome_pos;
	$end = $start + $numero;
	# $chrom_mate = $chr_mate;
	$start_mate = $genome_pos_mate;
	$end_mate = $genome_pos_mate + $numero;
	
	# Sacar secuencia de hg19 para BLAT a GRCh38
	$reads = "/home/xspuente/downloads/samtools-0.1.19/samtools faidx /data/human_ref/hg19_sanger/hg19.fa $chrom:$start-$end";
	@output = qx{$reads};
	chomp($output[1]);
	if ($numero > 120){
		chomp($output[2]);
		chomp($output[3]);
		$lectura_limpia = "$output[1]" . "$output[2]" . "$output[3]";
	}
	elsif ($numero > 60){
		chomp($output[2]);
		$lectura_limpia = "$output[1]" . "$output[2]";
	}
	else{
		$lectura_limpia = $output[1];
	}
	my $comm = "echo \"\>tmp\n$lectura_limpia\" | $blat_command2";
	my @brest = `$comm`;
	my @bres = sort {blatscore($b) <=> blatscore($a)} @brest;
	my $first = shift @bres;
	my @f1 = split(/\s+/, $first);
	$chrom_38 = $f1[1];	# $chrom_38 = $f1[1] = $chrom_mate_38
	$pos_38 = $f1[8];

    # Sacar secuencia de hg19 de la mate para BLAT a GRCh38
	$reads = "/home/xspuente/downloads/samtools-0.1.19/samtools faidx /data/human_ref/hg19_sanger/hg19.fa $chrom:$start_mate-$end_mate";
	@output = qx{$reads};
	chomp($output[1]);
	if ($numero > 120){
		chomp($output[2]);
		chomp($output[3]);
		$lectura_limpia = "$output[1]" . "$output[2]" . "$output[3]";
	}
	elsif ($numero > 60){
		chomp($output[2]);
		$lectura_limpia = "$output[1]" . "$output[2]";
	}
	else{
		$lectura_limpia = $output[1];
	}
	my $comm = "echo \"\>tmp\n$lectura_limpia\" | $blat_command2";
	my @brest = `$comm`;
	my @bres = sort {blatscore($b) <=> blatscore($a)} @brest;
	my $first = shift @bres;
	my @f1 = split(/\s+/, $first);
	# my $chrom_mate_38 = $f1[1];
	my $pos_mate_38 = $f1[8];
	
	# Tercer blat para alinear la secuencia en hg38 y compararlo con la secuencia alineada en hg19
	my $comm = "echo \"\>tmp\n$lectura\" | $blat_command2";
	my @brest = `$comm`;
	my @bres = sort {blatscore($b) <=> blatscore($a)} @brest;
	if (not $bres[0]){
		# print "\n3\n";
		next LINE;
	}
	my $first = shift @bres;
	my @f1 = split(/\s+/, $first);
	if (($f1[1] ne $chrom_38 ||
		($f1[8]>$pos_38 + $OFFSET && $f1[9]>$pos_38 + $OFFSET) ||
		($f1[8]<$pos_38 - $OFFSET && $f1[9]<$pos_38 - $OFFSET))
		|| ($f1[1] eq $chrom_38 && (abs($pos_mate_38 - $f1[8])<100000))){
			next LINE;
	}
	
	# Procesamos el resto de resultados del BLAT
	foreach my $i (@bres){
		my @f2 = split(/\s+/, $i);
		if ($f2[2]>80 && $f2[1] eq $chrom_38 && (abs($pos_mate_38 - $f2[8])<100000)){
				next LINE;
		}
	}
	print "$linea\n";
}
