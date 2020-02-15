
tclForces               on
tclForcesScript {
    set starta 17997  
    set enda   19580
    set startb 19581  
    set endb   201584
    set LB  00.0
    set UB 215.0
    set lb -40.0
    set ub  30.0
    set ff1 {0.0 0.0 0.02}
    set ff2 {0.0 0.0 0.05}
    set flist1 {}
    for {set i $starta} {$i<$enda} {incr i 1} {
    lappend flist1 $i
    addatom $i
      }
    set flist2 {}
    for {set i $startb} {$i<$endb} {incr i 1} {
    lappend flist2 $i
    addatom $i
      }
    proc calcforces {} {
    global flist1 flist2 UB LB lb ub ff1 ff2 
    loadcoords coorList
    foreach i $flist1 {
    set x [lindex $coorList($i) 0]
    set y [lindex $coorList($i) 1]
    set z [lindex $coorList($i) 2]
        if { $z<$UB && $z>$LB } {
        addforce $i $ff1
        }
        }
    foreach i $flist2 {
    set x [lindex $coorList($i) 0]
    set y [lindex $coorList($i) 1]
    set z [lindex $coorList($i) 2]
        if { $z<$ub && $z>$lb } {
        addforce $i $ff2
        }
        }
     }
  }

