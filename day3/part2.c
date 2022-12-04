#include <stdio.h>
#include <stdlib.h>

// basically a string
typedef struct {
	unsigned sz;
	char item[48];
} Rucksack;

unsigned char_value(char c) {
	return (c > 96) ? c - 96 : c - (64 - 26);
}

Rucksack get_overlapping(Rucksack src, Rucksack dest) {
	Rucksack overlapping = {0};
	for (int i = 0; i < src.sz; i++) {
		for (int j = 0; j < dest.sz; j++) {
			if (src.item[i] == dest.item[j]) {
				overlapping.item[overlapping.sz] = src.item[i];
				overlapping.sz++;
				continue;
			}
		}
	}
	return overlapping;
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
			sacks[sack_count] = (Rucksack) {cursor};
			for (int i = 0; i < cursor; i++)
				sacks[sack_count].item[i] = line[i];
			sack_count++;
			cursor = 0;
			continue;
		}
		line[cursor] = c;
		cursor++;
	}
	
	unsigned total = 0;
	for (int i = 0; i < 300; i+= 3) {
		Rucksack o = get_overlapping(get_overlapping(sacks[i], sacks[i + 1]), sacks[i + 2]);
		total += char_value(o.item[0]);
	}

	printf("total: %u\n", total);
}
