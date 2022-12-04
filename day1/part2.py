f = open("calories.txt", "r")
data = f.read()
f.close()

to_int = lambda n : 0 if n == "" else int(n)
to_sum = lambda inv : sum(map(to_int, inv.split("\n")))
elves_total = sorted(map(to_sum, data.split("\n\n")))
print(sum(elves_total[-3:]))
