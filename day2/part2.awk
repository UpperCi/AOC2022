# lookup table to convert char to int
BEGIN { C = "" ; for ( i = 0 ; ++i < 256 ; ) C = C sprintf ( "%c" , i ) }

{
	op = index(C, $1) - 64
	target = index(C, $2) - 89
	pl = op + target
	if (pl == 0) pl = 3
	if (pl == 4) pl = 1
	sum += pl 
	sum += (target + 1) * 3
}

END { print sum }
