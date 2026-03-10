#This script loads the entire system once, then iterates over all unique segnames, 
#performing alignment and RMSD computation against frame 0. The full coordinate set ($all) is moved
#during alignment, which means every frame update touches all atoms in memory.

# Open output file for RMSD values
set outfile [open "benchmark.dat" w]

set t0 [clock milliseconds]
set mem0 [lindex [exec ps -o rss= -p [pid]] 0]
# Load PSF and DCD files
mol new envelope.tpr
mol addfile traj.dcd waitfor all

set t1 [clock milliseconds]
set elapsed [expr {($t1 - $t0) / 1000.0}]
puts "Load System: ${elapsed}s"
puts $outfile "Load System: ${elapsed}s"

# Split by segname and write separate PSF/DCD per segment
set sel [atomselect top all]
set segnameList [lsort -unique [$sel get segname]]
$sel delete

# Get number of frames
set nframes [molinfo top get numframes]

set all [atomselect top all]

foreach segname $segnameList {
    set t0 [clock milliseconds]

    # Define protein selection for RMSD calculation
    set ref [atomselect top "segname $segname" frame 0]
    set sel [atomselect top "segname $segname"]
    # Compute RMSD for each frame
    for {set i 0} {$i < $nframes} {incr i} {
        $sel frame $i

        # Align to reference frame
        $all move [measure fit $sel $ref]

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
