# lookup table to convert char to int
BEGIN { C = "" ; for ( i = 0 ; ++i < 256 ; ) C = C sprintf ( "%c" , i ) }

{
	op = index(C, $1) - 64
	pl = index(C, $2) - 87
	sum1 += pl
	if (pl == op) sum1 += 3
	if (pl == (op) % 3 + 1) sum1 += 6

	target = pl - 2
	pl = op + target
	if (pl == 0) pl = 3
	if (pl == 4) pl = 1
	sum2 += pl 
	sum2 += (target + 1) * 3
}

END { print sum1; print sum2 }
