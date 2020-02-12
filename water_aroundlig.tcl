set frames [molinfo top get numframes]
set fp [open "waters.txt" w]
set ligand "resid 1 to 11"
for {set i 0} {$i < $frames} {incr i} {
                #puts "Frame: $i"
                set a [atomselect top "water within 3 of $ligand"]
                $a frame $i
                $a update
                set num [$a num]
                puts  "$i  $num"
		puts $fp "$i  $num"
                $a delete
}

close $fp 
