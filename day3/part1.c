#include <stdio.h>
#include <stdlib.h>

// basically just two strings with the same size
typedef struct {
	unsigned size;
	char *items[2];
} Rucksack;

unsigned char_value(char c) {
	return (c > 96) ? c - 96 : c - (64 - 26);
}

int main() {
	Rucksack sacks[300];
	unsigned sack_count = 0;
	
	char line[48];
	unsigned cursor = 0;
	char c;
	FILE *file;
	file = fopen("items.txt", "r");
	// read sacks from file
	while ((c = getc(file)) != EOF) {
		if (c == '\n') {
			unsigned sz = cursor / 2;
			Rucksack r = {cursor / 2, { malloc(sz), malloc(sz) } };

			for (unsigned i = 0; i < sz; i++) {
				r.items[0][i] = line[i];
				r.items[1][i] = line[i + sz];
			}
			
			sacks[sack_count] = r;
			sack_count++;
			cursor = 0;
			continue;
		}
		line[cursor] = c;
		cursor++;
	}

	unsigned total = 0;
	for (unsigned i = 0; i < sack_count; i++) {
		Rucksack r = sacks[i];
		for (unsigned j = 0; j < r.size; j++) {
			for (unsigned l = 0; l < r.size; l++) {
				if (r.items[0][j] == r.items[1][l]) {
					total += char_value(r.items[0][j]);
					goto next_sack;
				}
			}
		}
		next_sack:;
	}
	printf("total: %u\n", total);
}
