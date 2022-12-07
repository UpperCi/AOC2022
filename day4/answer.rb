parsed = File.read("sched.txt").split
  .map { |s| s.split(',')
  .map { |s| s.split('-')
  .map { |s| s.to_i } } }
puts ( parsed
  .select { |a| ((a[0][0] <=> a[1][0]) + (a[0][1] <=> a[1][1])).abs <= 1 }
  .count
)
puts ( parsed
  .select { |a| (a[0][1] >= a[1][0] and a[0][1] <= a[1][1]) or \
                (a[0][0] <= a[1][1] and a[0][0] >= a[1][0]) or \
                (a[1][0] <= a[0][1] and a[1][0] >= a[0][0]) or \
                (a[1][0] >= a[0][1] and a[1][0] <= a[0][0]) }
  .count )
