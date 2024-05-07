# first load ref file, then load dcd file
# for calcuation of Rotational RMSD
# system number
set sy 1

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

    #set sel [atomselect top "segname PROA PROB and name CA"]
    #set ref [atomselect 0 "segname PROB and name CA"]

    set outfile [open copy$i.dat w]

    set nf [molinfo 1 get numframes]

    # now starting rmsd calculation
    set j 0
    while {$j < $nf} {
        # aligning PROA 
        set ref [atomselect 0 "segname PROA and name CA"]
        set compare [atomselect top "segname PROA and name CA" frame $j]
        set trans_mat [measure fit $compare $ref]
        $compare move $trans_mat
        
        # aligning PROB
        set ref [atomselect 0 "segname PROB and name CA"]
        set compare [atomselect top "segname PROB and name CA" frame $j]
        set trans_mat [measure fit $compare $ref]
        $compare move $trans_mat
        set rmsd [measure rmsd $compare $ref]
        puts "Rotational RMSD =  $rmsd"
        puts $outfile "$j       $rmsd"
        set j [expr {$j + $stride}]
    }

    close $outfile
    # update i 
    set i [expr {$i + 1}]
}

exit