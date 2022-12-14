const std = @import("std");
// https://xyquadrat.ch/2021/12/01/reading-files-in-zig/
const ArrayList = std.ArrayList;
const data = @embedFile("path.txt");
const allocator = std.heap.page_allocator;

const Tile = struct {
      // top down left right
      height: u8, adjacent: [4]bool, shortest: usize, prev: usize
};

fn sub_usize(a: usize, b: usize) usize {
      return if (b > a) a else a - b;
}

fn sub_iusize(a: usize, b: usize) isize {
      return @bitCast(isize, a) - @bitCast(isize, b);
}

fn rel_dir(pos: usize, width: usize, dir: usize) usize {
      return switch (dir) { // top bottom left left right
            0 => sub_usize(pos, width),
            1 => pos + width,
            2 => sub_usize(pos, 1),
            3 => pos + 1,
            else => pos
      };
}

pub fn reset_tiles(tiles: []Tile) void {
      for (tiles) |_, i| {
            tiles[i].shortest = std.math.maxInt(usize);
      }
}

pub fn find_path(tiles: []Tile, start: usize, width: usize) !void {
      _ = tiles;
      var queue = ArrayList(usize).init(allocator);
      tiles[start].shortest = 0;
      try queue.append(start);
      while (queue.items.len > 0) {
            var next_index: usize = 0; // value, not index
            var shortest: usize = std.math.maxInt(usize);
            // get shortest node
            for (queue.items) |q, i| { 
                  var t = tiles[q];
                  if (t.shortest < shortest) {
                        shortest = t.shortest;
                        next_index = i;
                  }
            }
            var next_tile = queue.orderedRemove(next_index);
            var next = tiles[next_tile];
            for (next.adjacent) |valid, dir| {
                  if (valid) {
                        var pos = rel_dir(next_tile, width, dir);
                        if (tiles[pos].shortest > shortest + 1) {
                              tiles[pos].shortest = shortest + 1;
                              try queue.append(pos);
                        }
                  }
            }
      }
}

pub fn main() !void {
      var lines_raw = std.mem.tokenize(u8, data, "\n");
      var lines = ArrayList(u8).init(allocator);
      var line_length: usize = 0;
      while (lines_raw.next()) |l| {
            if (line_length == 0) {
                  line_length = l.len;
            }
            try lines.appendSlice(l);
      }

      var tiles = try allocator.alloc(Tile, lines.items.len);
      const tile_count = lines.items.len;
      var start: usize = 0;
      var end: usize = 0;
      for (lines.items) |l, i| {
            tiles[i].height = switch (l) {
                  'S' => start: { start = i; break :start 0; },
                  'E' => end: { end = i; break :end 25; },
                  97...123 => @truncate(u8, l - 97),
                  else => return
            };
            tiles[i].adjacent = .{false, false, false, false};
            tiles[i].shortest = std.math.maxInt(usize);
            tiles[i].prev = 0;
      }
      // check valid neighbours
      for (tiles) |t, i| {
            adjacent: for (t.adjacent) |_, dir| {
                  var cell = rel_dir(i, line_length, dir);
                  if (cell >= tile_count or cell == i) {
                        tiles[i].adjacent[dir] = false;
                        continue :adjacent;
                  }
                  var diff: isize = sub_iusize(tiles[cell].height, t.height);
                  tiles[i].adjacent[dir] = (diff <= 1);
            }
      }
      try find_path(tiles, start, line_length);
      std.debug.print("length S-E: {}\n", .{tiles[end].shortest});
      var shortest_length: usize = std.math.maxInt(usize);
      for (tiles) |t, i| {
            if (t.height == 0) {
                  reset_tiles(tiles);
                  try find_path(tiles, i, line_length);
                  var length = tiles[end].shortest;
                  if (length < shortest_length) {
                        shortest_length = length;
                  }
            }
      }
      std.debug.print("shortest a-E: {}\n", .{shortest_length});
}
