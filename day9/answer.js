const DATA = await Deno.readTextFile("moves.txt");
const MOVE_INDEX = {
	"U": [0, -1],
	"D": [0, 1],
	"L": [-1, 0],
	"R": [1, 0],
};
let moves = DATA.split("\n")
	.filter((l) => l != "")
	.map((d) => d.split(" "))
	.map((d) => [MOVE_INDEX[d[0]], parseInt(d[1])]);

const make_rope = (n, a = []) => (n - 1) ?
	make_rope(n - 1, [...a, [0, 0]]) :
	[...a, [0, 0]];

function move_segment(r, seg, dir, path) {
	let set_path = false;
	r[seg][0] += dir[0];
	r[seg][1] += dir[1];
	if (seg == r.length - 1) {
		path[`${r[seg][0]}-${r[seg][1]}`] = true;
		return;
	}
	let d = [r[seg][0] - r[seg + 1][0], r[seg][1] - r[seg + 1][1]];
	let dabs = d.map((n) => Math.abs(n));
	if (dabs[0] > 1 || dabs[1] > 1) {
		if (dabs[0] == dabs[1]) {
			d[0] -= Math.sign(d[0]);
			d[1] -= Math.sign(d[1]);
			move_segment(r, seg + 1, [d[0], d[1]], path);
			return;
		}
		let dmax = (dabs[0] > dabs[1]) ? 0 : 1;
		d[dmax] -= Math.sign(d[dmax]);
		move_segment(r, seg + 1, [d[0], d[1]], path);
	}
}

function move_rope(r) {
	let path = {"0-0": true};
	for (let m of moves) {
		for (let _ = 0; _ < m[1]; _++) {
			move_segment(r, 0, m[0], path);
		}
	}
	return (Object.keys(path).length);
}

console.log(move_rope(make_rope(2)));
console.log(move_rope(make_rope(10)));
