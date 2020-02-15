
tclForces               on
tclForcesScript {
set natom 3
set atom(1) {300 350 400 500 600 700 800}
set atom(2) {1190 1250 1290 1390 1490 1590 1690}
set atom(3) {2080 2150 2180 2280 2380 2480 2580}

for {set i 1} {$i <= $natom} {incr i} {
set n($i) {}
foreach index $atom($i) { 
addatom [expr $index+1] 
lappend n($i) [expr $index+1]
}; 
}

proc calcforces {} {
global natom n
 loadcoords c
 #coordinate of fixed point
 set ox -2; set oy 04; set oz -2

 for {set i 1} {$i <= $natom} {incr i} {

 #find coordinate of moving part
 foreach index $n($i) {
 set xo($i) [lindex $c($index) 0]
 set yo($i) [lindex $c($index) 1]
 set zo($i) [lindex $c($index) 2]

 #find unit vector (direction)
 set x [expr $xo($i)-$ox]
 set y [expr $yo($i)-$oy]
 set z [expr $zo($i)-$oz]
 set r [expr $x*$x+$y*$y+$z*$z]
 set x [expr $x/$r]
 set y [expr $y/$r]
 set z [expr $z/$r]

 #apply force
 set k 2.00
 set force {}
 lappend force [expr -$k*$x]
 lappend force [expr -$k*$y]
 lappend force [expr -$k*$z]
 addforce $index $force

 }
 }
}
}

