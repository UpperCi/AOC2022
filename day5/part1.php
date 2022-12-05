<?php
$crate_parts = explode("\n\n", file_get_contents("crates.txt"));
$moves = $crate_parts[1];
$conf = explode("\n ", $crate_parts[0]);
// maps lines to array of characters, space = empty
// PHP <3 FP
$lines = array_map(
	function($a) { return array_map(
		function ($s) { return $s[0]; },
		array_slice(explode("[", $a), 1)); },
	explode("\n", str_replace("    ", " [ ]", $conf[0])));
$stacks = [];

for ($i = 0; $i <= 8; $i++) {
	$stacks[$i] = [];
	foreach (array_reverse($lines) as $k => $l) {
		if ($l[$i] == " ") continue;
		$stacks[$i][$k] = $l[$i];
	}
}

foreach(explode("\n", $moves) as $move) {
	if ($move == "") continue;
	$m = explode(" ", $move);
	$no = $m[1];
	$src_i = $m[3] - 1;
	$dest_i = $m[5] - 1;
	$src = &$stacks[$src_i];
	$src_cnt = count($src);
	$dest = &$stacks[$dest_i];
	for ($i = 0; $i < $no; $i++) {
		array_push($dest, array_pop($src));
	}
}

foreach ($stacks as $stack) echo end($stack);
