package main

import (
	"fmt"
	"os"
	"strings" 
	"strconv"
	"sort"
)

type Monkey struct {
	id uint8
	items []uint64
	op []string
	cond uint8 // divisible
	target_true uint8
	target_false uint8
	inspects uint64
}

func parse_monkey(mstr string) Monkey {
	lines := strings.Split(mstr, "\n");
	mid := strings.Split(lines[0], " ")[1][0] - 48
	items_str := strings.Split(strings.Split(lines[1], ": ")[1], ", ")
	var items []uint64
	for _, i := range items_str {
		item, _ := strconv.Atoi(i)
		items = append(items, uint64(item))
	}
	op := strings.Split(strings.Split(lines[2], " = ")[1], " ")
	div, _ := strconv.Atoi(strings.Split(lines[3], "by ")[1])
	ttrue, _ := strconv.Atoi(strings.Split(lines[4], "monkey ")[1])
	tfalse, _ := strconv.Atoi(strings.Split(lines[5], "monkey ")[1])
	return Monkey {uint8(mid), items, op, uint8(div), uint8(ttrue), uint8(tfalse), 0}
}

func operand(item uint64, op string) uint64 {
	if op == "old" {
		return item
	}
	new_item, _ := strconv.Atoi(op)
	return uint64(new_item);
}

func operate(left uint64, right uint64, op string) uint64 {
	if op == "*" {
		return left * right
	}
	return left + right
}

func monkey_throw(i int, mks []Monkey, reduce_worry bool, max_div uint64) {
	m := mks[i]
	for _, item := range m.items {
		mks[i].inspects++
		left := operand(item, m.op[0])
		right := operand(item, m.op[2])
		new_item := operate(left, right, m.op[1])
		if reduce_worry {
			new_item /= 3
		}
		new_item %= max_div
		target := m.target_false
		if new_item % uint64(m.cond) == 0 {
			target = m.target_true
		}
		mks[target].items = append(mks[target].items, new_item)
	}
	mks[i].items = []uint64{}
}

func main() {
	bytes, _ := os.ReadFile("mankey.txt")
	data := string(bytes)
	monkeystr := strings.Split(data, "\n\n");
	var monkeys []Monkey
	for _, m := range monkeystr {
		monkeys = append(monkeys, parse_monkey(m))
	}

	monkes := make([]Monkey, len(monkeys))
	copy(monkes, monkeys)

	var max_div uint64 = 1
	for _, m := range monkeys {
		max_div *= uint64(m.cond)
	}

	for i := 0; i < 20; i++ {
		for i, _ := range monkeys {
			monkey_throw(i, monkeys, true, max_div)
		}
	}
	for i := 0; i < 10000; i++ {
		for i, _ := range monkes {
			monkey_throw(i, monkes, false, max_div)
		}
	}

	sort.Slice(monkeys, func(a, b int) bool {
		return monkeys[a].inspects > monkeys[b].inspects
	})
	sort.Slice(monkes, func(a, b int) bool {
		return monkes[a].inspects > monkes[b].inspects
	})
	
	fmt.Println(monkeys[0].inspects * monkeys[1].inspects);
	fmt.Println(monkes[0].inspects * monkes[1].inspects);
}
