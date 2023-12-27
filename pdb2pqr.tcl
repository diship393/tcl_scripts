# write pqr file from a trajectory/pdb
# extracted from cafe plugin - 27/12/2023

proc write_pqr { sel fname } {
    set fp [open $fname w]
    foreach n [$sel get serial] name [$sel get name] \
            rname [$sel get resname] rid [$sel get resid] \
            x [$sel get x] y [$sel get y] z [$sel get z] \
            q [$sel get charge] r [$sel get radius] {
        set name [format "%-3s" $name]
        puts $fp [format "ATOM  %5i %4s %3s  %4i    %8.3f%8.3f%8.3f %7.4f%7.4f" \
                  $n $name $rname $rid $x $y $z $q $r]
    }
    close $fp
}
