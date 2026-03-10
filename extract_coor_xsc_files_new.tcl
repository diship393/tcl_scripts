proc writeXSC { j fr } {
  set outXSC [open "image${j}.restart.xsc" w]
  animate goto $fr
  puts $outXSC "\# NAMD extended system configuration output file"
  puts $outXSC "\#\$LABELS step a_x a_y a_z b_x b_y b_z c_x c_y c_z o_x o_y o_z s_x s_y s_z s_u s_v s_w"
  puts $outXSC "0 [molinfo top get a] 0 0 0 [molinfo top get b] 0 0 0 [molinfo top get c] [lindex [molinfo top get center] 0 0] [lindex [molinfo top get center] 0 1] [lindex [molinfo top get center] 0 2] 0 0 0 0 0 0"
  close $outXSC
}

mol new done/step5_input.psf
mol addfile done/qwrapped_combined_SMD_traj.dcd waitfor all

# deleting the frames between frame 550 to 1000
animate delete beg 550 end 1000 top

#set sel1 [atomselect top "protein and name CA and ((resid 20 to 40) or (resid 46 to 81) or (resid 138 to 148) or (resid 154 to 158) or (resid 214 to 228) or (resid 230 to 270))"]
#set sel2 [atomselect top "protein and name CA and ((resid 88 to 116) or (resid 286 to 307) or (resid 314 to 330) or (resid 333 to 346) or (resid 352 to 383) or (resid 391 to 407) or (resid 414 to 426) or (resid 431 to 463))"]
set all [atomselect top all]

#set start_dz 6.68
#set end_dz -4.94

set image_N 64
set image_N1 [expr {$image_N - 1}]

set nf [molinfo top get numframes]
set i 0

set subint_length [expr {$nf - $i}]
set bin_width [expr {int($subint_length / $image_N1)}]
puts "uniformly extracting from the traj"
puts "bin width = $bin_width"

set count 0
puts "count = $count"
while {$i < $nf} {
  $all frame $i 
  $all writenamdbin image${count}.restart.coor 
  writeXSC $count $i
  set i [expr {$i + $bin_width}]
  set count [expr {$count + 1}]
}

exit
