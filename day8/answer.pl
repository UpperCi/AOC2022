#!/usr/bin/perl
use warnings;
use strict;

# read a file, apparently
open my $fh, '<', 'tree.txt' or die "Can't open file $!";
my $file_content = do { local $/; <$fh> };
# parse to array
my @data = map { [split //, $_] } (split '\n', $file_content);
my @visible = map_to_0(@data);

my $total = 0;
my $max_view = 0;
my $range = $#data;
# horizontal lines
for my $j (0 .. $range) {
	my $highest = -1;
	my $highest_y = -1;
	for my $_i (-$range .. $range) {
		my $i = abs($_i);
		unless ($i) { 
			$highest = -1;
			$highest_y = -1;
		}
		# horizontal
		my $v = @{$data[$j]}[$i];
		if ($v > $highest) {
			$highest = $v;
			unless ($visible[$j][$i]) {
				$total++;
				$visible[$j][$i] = 1;
			}
		}
		# vertical
		$v = @{$data[$i]}[$j];
		if ($v > $highest_y) {
			$highest_y = $v;
			unless ($visible[$i][$j]) {
				$total++;
				$visible[$i][$j] = 1;
			}
		}
		if ($_i >= 0) {
			my $new_view = 1;
			my $vmax = @{$data[$j]}[$i];
			# right
			my $temp_view = 0;
			for my $x ($i + 1 .. $range) {
				$temp_view++;
				if (@{$data[$j]}[$x] >= $vmax) { last; }
			}
			$new_view *= $temp_view;
			$temp_view = 0;
			# left
			for my $_x (0 .. $i - 1) {
				$temp_view++;
				if (@{$data[$j]}[$i - $_x - 1] >= $vmax) { last; }
			}
			$new_view *= $temp_view;
			$temp_view = 0;
			# down
			for my $y ($j + 1 .. $range) {
				$temp_view++;
				if (@{$data[$y]}[$i] >= $vmax) { last; }
			}
			$new_view *= $temp_view;
			$temp_view = 0;
			# left
			for my $_y (0 .. $j - 1) {
				$temp_view++;
				if (@{$data[$j - $_y - 1]}[$i] >= $vmax) { last; }
			}
			$new_view *= $temp_view;
			if ($new_view > $max_view) {
				$max_view = $new_view;
			}
		}
	}
}
print $total;
print "\n";
print $max_view;
print "\n";

sub map_to_0 {
	map { [map { 0 } @$_] } @_;
}
