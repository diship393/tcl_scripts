proc prom_z {selection frame} {
set mol [$selection molindex]
set sel1 [atomselect $mol [$selection text] frame $frame]
set coords1 [$sel1 get {x y z}]
set sumz 0
foreach coord1 $coords1 {
  set z1 [lindex $coord1 2]
   set sumz [expr $sumz + $z1]
 }
return [expr $sumz / ([$selection num] + 0.0)]
}

set outfile [open thickness.txt w];
puts $outfile "Frame thickness"
set nf [molinfo top get numframes]
set sel1 [atomselect top "mass 31 and resid 1 to 64" ]
set sel2 [atomselect top "mass 31 and resid 65 to 128"]
for {set i 0 } {$i < $nf } { incr i } {
set z1 [prom_z $sel1 $i]
set z2 [prom_z $sel2 $i]
set thickness [expr $z1 - $z2]
puts $outfile "$i $thickness"
}
close $outfile

