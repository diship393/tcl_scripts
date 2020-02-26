source center_of_mass.tcl
set outfile [open com_bilayer.dat w]
set nf [molinfo top get numframes]
set i 0
#set prot [atomselect top "index >17151 && index < 17263"]
# changed
set prot [atomselect top "index >=0 && index < 17253"]
while {$i < $nf} {

    $prot frame $i
    $prot update

    set i [expr {$i + 1}]
    set com_mov [center_of_mass $prot]
    puts $outfile "$i $com_mov"

}

close $outfile
exit

