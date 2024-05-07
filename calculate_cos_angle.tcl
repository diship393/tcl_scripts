# calculates the cosine of the angle between Z axis and third princiapl axis
# required VMD GUI to be open - can't run through command line 
# written by - Diship Srivastava
# 07/05/2024

# first load ref file, then load dcd file

# system number
set sy 5

package require Orient
namespace import Orient::orient

set Z_axis {0 0 1}

# load files - ref file 
mol new ../trajs/sys$sy/gA.psf
mol addfile ../trajs/sys$sy/ref.pdb 

set stride 1

set i 1
while {$i < 16} {
    puts "trajectory number = $i"
    # load files - traj
    mol new ../trajs/sys$sy/gA.psf
    mol addfile ../trajs/sys$sy/copy$i.dcd waitfor all

    # output 
    set outfile [open copy$i.dat w]

    set nf [molinfo 1 get numframes]

    # now starting calculation
    set j 0
    while {$j < $nf} {

        # compute principal vectors
        set sel [atomselect top "all" frame $j]
        set I [draw principalaxes $sel]
        # selecting third principal axis 
        set I3 [lindex $I 2]
        set cos_angle [vecdot $I3 $Z_axis] ; # both I3 and Z_axis are unit vectors
        puts "cos angle =  $cos_angle"
        puts $outfile "$j       $cos_angle"

        set j [expr {$j + $stride}]
    }

    close $outfile
    # update i 
    set i [expr {$i + 1}]
}

exit