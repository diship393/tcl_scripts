proc minmax {selection frame} {
	set mol [$selection molindex]
	set sel1 [atomselect $mol [$selection text] frame $frame]
	set sx [$sel1 get x]
	set sy [$sel1 get y]
	set sz [$sel1 get z]
	set minx [lindex $sx 0]
        set miny [lindex $sy 0]
        set minz [lindex $sz 0]
        set maxx $minx
        set maxy $miny
        set maxz $minz
        foreach x $sx y $sy z $sz {
        if {$x < $minx} {set minx $x} else {if {$x > $maxx} {set maxx $x}}
        if {$y < $miny} {set miny $y} else {if {$y > $maxy} {set maxy $y}}
        if {$z < $minz} {set minz $z} else {if {$z > $maxz} {set maxz $z}}
        }
        set x1 [expr $maxx - $minx]
	set y1 [expr $maxy - $miny]

        set a1 [expr $x1*$y1]
        return $a1
   }

   # change number of lipids
   set num_lipids 128
   set outfile [open area_per_lipid.dat w];
   puts $outfile "Frame apl"
   set nf [molinfo top get numframes]
set sel1 [atomselect top "resid 1 to 64" ]
set sel2 [atomselect top "resid 65 to 128"]
for {set i 0 } {$i < $nf } { incr i } {
set z1 [minmax $sel1 $i]
set z2 [minmax $sel2 $i]
set apl [expr ($z1+$z2)/$num_lipids]
puts $outfile "$i $apl"
}
close $outfile
