# Compute MSD and tau for a particular selection 
# based on diffusion coeff plugin of VMD 
# requires qwrap to unwrap the trajectories

# load qwrap
load /home/diship/software/vmd_plugin/qwrap/qwrap.so

mol new ../../1.completed_drude_runs/1.state1_rep1/3.drude_run/step2_drude.psf
mol addfile ../../1.completed_drude_runs/1.state1_rep1/3.drude_run/qwrapped_drude.dcd waitfor all first 8000 last 9999

# unwrap the traj
qunwrap sel "all" 

set stride 1
# edit a needed
set dt 0.01

set nf [molinfo top get numframes]
set interval_to [expr {$nf - 1}]

# setting tau range
set tau_start [expr {$nf/10}]
set tau_end [expr {$nf/2}]
set tau_stride [expr {$nf / 50}]

set outfile [open drude_ff_s1r1_msd.csv w]

# from vmd diffusion coeff plugin
# Return a zero-centered version of the input list
proc veccenter {l} {
    set m [vecmean $l]
    set N [llength $l]
    set mN [lrepeat $N $m]
    set r [vecsub $l $mN]
    return $r
}

# Requires atomselect, axis ("x", "y" or "z"), start and end frames.
# Returns the squared distance moved along that axis
proc delta2_between {as axis t0 t1} {
    $as frame $t0
    set v0 [$as get $axis]
    $as frame $t1
    set v1 [$as get $axis]

    # removing drift
	set v0 [veccenter $v0]
	set v1 [veccenter $v1]
    
    set dv [vecsub $v1 $v0]
    set dv2 [vecdot $dv $dv]
    return $dv2
}

proc msd_between {as t0 t1} {
    set N [$as num]

    set dx2 0
    set dy2 0
    set dz2 0
    
	set dx2 [delta2_between $as x $t0 $t1]
	set dy2 [delta2_between $as y $t0 $t1]
	set dz2 [delta2_between $as z $t0 $t1]
    set msd [expr ($dx2+$dy2+$dz2)/$N ]
    return $msd
}

set sel [atomselect top "name OH2"]
# main
set j $tau_start 
puts $outfile "#tau     average_MSD"
puts $outfile "#unit = ns  angstrom^2 "
while {$j <= $tau_end} {
    set msdavg 0
	set ns 0

    set t0 0
    while {$t0<[expr $interval_to-$j]} {
        # take selection 
        
        set t1 [expr $t0+$j]
        set msd [msd_between $sel $t0 $t1]
        set msdavg [expr $msdavg+$msd]
        incr ns

        # update t0
        set t0 [expr {$t0  +  $stride}]
    }
    set msdavg [expr 1.*$msdavg/$ns]
    set tau1 [expr $j*$dt]

    # writing in file
    puts $outfile "$tau1        $msdavg"
    puts "$tau1        $msdavg"

    # update j
    set j [expr {$j + $tau_stride}]
}
close $outfile
exit
