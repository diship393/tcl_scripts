mol new ./pooled_aligned_trajs/rna_loop.psf
mol addfile ./pooled_aligned_trajs/pooled_aligned.dcd waitfor all

set stride 1
#default number of clusters
set num_cluster 5
set cutoff 2.0

set nf [molinfo top get numframes]

set start_frame 0
set last_frame [expr {$nf - 1}]

# alignment
set ref_sel [ atomselect top  "backbone" frame 0]
for {set i 0} {$i < $nf} {incr i} {
set compare_sel [ atomselect top "backbone" frame $i]
set transform_matrx [ measure fit $compare_sel $ref_sel ]
$compare_sel  move $transform_matrx
}
puts "Aligned w.r.t rna backbone"

# OUTPUT files
set file1 [open "CLUSTER-A.pdb" w]
set file2 [open "CLUSTER-B.pdb" w]
set file3 [open "CLUSTER-C.pdb" w]
set file4 [open "CLUSTER-D.pdb" w]
set file5 [open "CLUSTER-E.pdb" w]
set file6 [open "UNCLUSTER.pdb" w]
set logfile [open "cluster.log" w]

# selection
set sel [atomselect top "backbone"]

# Cluster
foreach {listA listB listC listD listE listF} [measure cluster $sel num $num_cluster cutoff $cutoff first $start_frame last $last_frame  step $stride distfunc rmsd ]

set nclustera [llength $listA]
set nclusterb [llength $listB]
set nclusterc [llength $listC]
set nclusterd [llength $listD]
set nclustere [llength $listE]
set nclusterf [llength $listF]

puts " CLUSTER-A ($nclustera) :\n $listA \n\n CLUSTER-B ($nclusterb)  :\n $listB \n\n CLUSTER-C ($nclusterc)  :\n $listC \n\n CLUSTER-D ($nclusterd)  :\n $listD \n\n CLUSTER-E ($nclustere)  :\n $listE \n\n UNCLUSTRED ($nclusterf) : \n $listF\n"         
puts $logfile  " CLUSTER-A ($nclustera) :\n $listA \n\n CLUSTER-B ($nclusterb)  :\n $listB \n\n CLUSTER-C ($nclusterc)  :\n $listC \n\n CLUSTER-D ($nclusterd)  :\n $listD \n\n CLUSTER-E ($nclustere)  :\n $listE  \n\n UNCLUSTRED ($nclusterf) : \n $listF\n" 

# saving each cluster
for {set i 0} {$i < $nf} {incr i} {
    # cluster A
    foreach list1 $listA {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> CLUSTER-A.pdb
        exec rm cluster$i.pdb
        }
    }

    # cluster B
    foreach list1 $listB {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> CLUSTER-B.pdb
        exec rm cluster$i.pdb
        }
    }

    # cluster C
    foreach list1 $listC {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> CLUSTER-C.pdb
        exec rm cluster$i.pdb
        }
    }

    # cluster D
    foreach list1 $listD {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> CLUSTER-D.pdb
        exec rm cluster$i.pdb
        }
    }

    # cluster E
    foreach list1 $listE {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> CLUSTER-E.pdb
        exec rm cluster$i.pdb
        }
    }

    # uncluster
    foreach list1 $listF {
        if {$i == $list1 } {
        [atomselect top "all" frame $i] writepdb cluster$i.pdb
        exec cat cluster$i.pdb >> UNCLUSTER.pdb
        exec rm cluster$i.pdb
        }
    }

}

close $file1
close $file2
close $file3
close $file4
close $file5
close $file6

exit