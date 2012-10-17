#!/usr/bin/env perl
# Licensed under ISC license
# Copyright (c) 2012
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;

use SVG;
use POSIX;
use Math::Trig;

my $svg = SVG->new(
  width  => '100%',
  height => '100%',
  style => {
	  background => 'black',
  },
);

my @palette;
push @palette, "#$_" for ( qw/98D936 DEEBCC 88F2F0 F7E4A8 FFD9E0/,
	qw/1E1E38 544562 FFB351 594C78 34130E/,
	qw/E69E8F C4857C 594B5C 2A3350 172548/,
	);


my $direction_level = [ [0,60,80], [20, 45] , [30, 45], [50], [30, 60], [45, 70], [60], [60], [60] ];

gen_tree(0, 20, 900, 40, 5 );

print $svg->xmlify;

sub gen_tree {
	my ($level, $x, $y, $length, $end_level) = @_;
	return if $end_level == $level;
	my $radius = 0.8 * $length;
	my $which_palette = int rand(@palette);
	$svg->circle( cx => $x, cy => $y,
		r => $radius, 
		style => {
			'stroke' => $palette[$which_palette],
			'stroke-width' => floor($level*0.5),
			'fill-opacity'=>'0.1',
		}
	);
	my $rand_conc = rand(10);
	$svg->circle( cx => $x, cy => $y,
		r => $radius*(1 + $_/10.0), 
		style => {
			'stroke' => $palette[ $which_palette - $_ ],
			'stroke-width' => floor($level*0.5),
			'fill-opacity'=>'0.00',
			'opacity' => '0.4',
		}
	) for 1..$rand_conc;
	for (0..@{$direction_level->[$level]}) {
		gen_tree($level+1,
		$x+($length+rand(1.6*$length))*cos(deg2rad $direction_level->[$level][$_]),
		$y-($length+rand(1.6*$length))*sin(deg2rad $direction_level->[$level][$_]),
		$length*1.6,
		$end_level
		);
	}
}