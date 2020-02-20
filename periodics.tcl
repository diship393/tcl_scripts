# Periodic Boundary Conditions
#
# you get the info to make the following from:
set sel [atomselect top all]
# cell basis vectors:
set m [measure minmax $sel]
foreach {j1 j2} $m {}
foreach {x2 y2 z2} $j2 {}
foreach {x1 y1 z1} $j1 {}
puts "x: [expr int($x2-$x1+4)] 0.00 0.00 "
puts "y: 0.00 [expr int($y2-$y1+4)] 0.00 "
puts "z: 0.00 0.00 [expr int($z2-$z1+4)] "
# cellOrigin:
measure center $sel

