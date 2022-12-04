f = open("calories.txt", "r")
data = f.read()
f.close()

highest = 0
for c in data.split("\n\n"):
    to_int = lambda n : 0 if n == "" else int(n)
    calories = sum(map(to_int, c.split("\n")))
    highest = max(calories, highest)
print(highest)
