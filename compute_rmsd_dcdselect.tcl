# This script first reads the full topology to extract the list of segnames, then deletes the molecule and iterates over each segment, 
#loading its dedicated PSF/DCD pair produced by SelectDCD. A key difference: alignment moves only the segment atoms ($sel move) rather
#than the entire system ($all move), which is both correct for isolated segments and significantly faster.

set outfile [open "benchmark_dcdselect.dat" w]

mol new envelope.tpr
# Split by segname and write separate PSF/DCD per segment
set sel [atomselect top all]
set segnameList [lsort -unique [$sel get segname]]
$sel delete
mol delete all

foreach segname $segnameList {
    set t0 [clock milliseconds]
    set mem0 [lindex [exec ps -o rss= -p [pid]] 0]

    mol new $segname.psf
    mol addfile $segname.dcd waitfor all

    # Get number of frames
    set nframes [molinfo top get numframes]

    set t1 [clock milliseconds]
    set elapsed [expr {($t1 - $t0) / 1000.0}]
    puts "Load System $segname: ${elapsed}s"
    puts $outfile "Load System $segname: ${elapsed}s"

    set t0 [clock milliseconds]

    # Define protein selection for RMSD calculation
    set ref [atomselect top "segname $segname" frame 0]
    set sel [atomselect top "segname $segname"]
    # Compute RMSD for each frame
    for {set i 0} {$i < $nframes} {incr i} {
        $sel frame $i

        # Align to reference frame
        $sel move [measure fit $sel $ref]

        # Compute RMSD
        set rmsd [measure rmsd $sel $ref]
    }
    $sel delete

    set t1 [clock milliseconds]
    set elapsed [expr {($t1 - $t0) / 1000.0}]

    set mem1 [lindex [exec ps -o rss= -p [pid]] 0]
    set mem_used [expr {($mem1 - $mem0) / 1024.0}]
    set mem_total [expr {$mem1 / 1024.0}]
    puts "segname $segname: ${elapsed}s | delta ... MB | total ... MB"
    puts $outfile "segname $segname: ${elapsed}s | delta ... MB | total ... MB"
}

close $outfile
