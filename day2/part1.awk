# lookup table to convert char to int
BEGIN { C = "" ; for ( i = 0 ; ++i < 256 ; ) C = C sprintf ( "%c" , i ) }

{
	op = index(C, $1) - 64
	pl = index(C, $2) - 87
	sum += pl
	if (pl == op) sum += 3
	if (pl == (op) % 3 + 1) sum += 6
}

END { print sum }
