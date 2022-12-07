// messy
use std::fs;
use std::collections::HashMap;

#[derive(Clone)]
enum Item {
	File(usize),
	// having calculated the directory size is optional
	Dir(Vec<String>, Option<usize>)
}

enum Line {
	CD(String),
	LS,
	ListDir(String),
	ListFile(String, usize)
}

impl Line {
	fn from_str(raw_s: &str) -> Line {
		let s = String::from(raw_s);
		let args: Vec<&str> = s.split(" ").collect();
		if let Some(a1) = args.get(0) { match a1 {
				&"$" => { match args.get(1).expect("Empty command!") {
						&"cd" => Line::CD(String::from(*args.get(2).unwrap())),
						&"ls" => Line::LS,
						_ => panic!("Invalid command") 
				} }
				&"dir" => Line::ListDir(String::from(*args.get(1).unwrap())),
				_ => Line::ListFile(String::from(*args.get(1).unwrap()), a1.parse().unwrap())
			}
		} else { panic!("Empty line!"); }
	}
}

fn calc_size(files: &mut HashMap::<String, Item>, dir: String) -> usize {
	let current_item = &files[&dir];
	if let Item::Dir(childs, _) = current_item.clone() {
		let mut size = 0;
		for i in childs.iter() {
			let path = dir.clone() + "/" + i;
			match files[&path] {
				Item::File(fsz) => { size += fsz },
				Item::Dir(_, _) => { size += calc_size(files, path) }
			}
		}
		files.insert(dir, Item::Dir(childs.clone(), Some(size)));
		return size;
	}
	panic!();
}

fn main() {
	let data = fs::read_to_string("files.txt").unwrap();
	let lines: Vec<Line> = data.lines().into_iter()
		.map(|l| Line::from_str(l))
		.filter(|l| if let Line::LS = l { false } else { true } ).collect();
	let mut wd: String = "~".to_string();
	let mut files = HashMap::<String, Item>::new();
	files.insert("~".to_string(), Item::Dir(Vec::new(), None));
	for l in lines.iter() {
		match l {
			Line::CD(s) => { match s.as_str() {
					".." => { 
						let nwd = wd.as_str();
						wd = nwd[..nwd.rfind("/").unwrap()].to_string(); },
					"/" => { },
					_ => { wd += &"/"; wd += s; }
				};
			},
			Line::ListDir(s) => {
				let path = wd.as_str().to_owned() + "/" + s;

				if let Item::Dir(mut childs, sz) = files[&wd].clone() {
					childs.push(s.clone());
					files.insert(path, Item::Dir(Vec::new(), None));
					files.insert(wd.clone(), Item::Dir(childs, sz));
				}
			},
			Line::ListFile(s, n) => {
				let path = wd.as_str().to_owned() + "/" + s;

				if let Item::Dir(mut childs, sz) = files[&wd].clone() {
					files.insert(path, Item::File(*n));
					childs.push(s.clone());
					files.insert(wd.clone(), Item::Dir(childs, sz));
				}
			}
			_ => {}
		};
	};
	calc_size(&mut files, "~".to_string());
	let flattened: Vec<usize> = files.iter().map(|(_, item)| match item {
		Item::File(_) => 0,
		Item::Dir(_, sz) => sz.unwrap()
	}).collect();
	let part1_sz: usize = flattened.clone().into_iter().filter(|n| n <= &100000 ).sum();
	println!("Part 1: {part1_sz}");
	if let Item::Dir(_, sz) = files["~"] {
		let unused = 70000000 - sz.unwrap();
		let needed = 30000000 - unused;
		let mut part2: Vec<usize> = flattened.clone().into_iter()
			.filter(|n| n >= &needed ).collect();
		part2.sort();
		println!("size: {:?}", part2.first());
	}
}
