# created on 21/02/2020
# applying force in z direction
tclForces               on
tclForcesScript {
#Want to force all atoms
set starta 17153
set enda   17263
set lb 22.5
set ub 30
# applied force
set lin_force {0.0 0.0 0.01} 
set atoms {}
for { set i $starta } { $i <$enda } { incr i 1} {
    lappend atoms $i
    addatom $i
}
proc calcforces { } {
        global atoms  lin_force ub lb
        loadcoords coorList
        foreach i $atoms {
        set x [lindex $coorList($i) 0]
        set y [lindex $coorList($i) 1]
        set z [lindex $coorList($i) 2]
        if { $z<$ub && $z>$lb } {
        addforce $i $lin_force
        }
        }
}
}

