mol new ../sys6.psf 
mol addfile ../sys6.dcd waitfor all


#atomselect get → always returns a list
#Even for 1 atom → list of length 1
#For vector math → always extract with lindex 0

set outfile [open sys6_top.dat w]

# Reference axis (Z-axis)
set zaxis {0 0 1}
set nf [molinfo top get numframes]

for {set i 0} {$i < $nf} {incr i} {
	set sel1 [atomselect top "water and noh and z < 7.5 and z >  0" frame $i]
	set sel1_resid [$sel1 get resid ]

	foreach resid1 $sel1_resid {
		set selO [atomselect top "water and resid $resid1 and name OH2" frame $i]
		set selH1 [atomselect top "water and resid $resid1 and name H1" frame $i]
		set selH2 [atomselect top "water and resid $resid1 and name H2" frame $i]
		
		set coord_O [lindex [$selO get {x y z}] 0]
		set coord_H1 [lindex [$selH1 get {x y z}] 0]
		set coord_H2 [lindex [$selH2 get {x y z}] 0 ]
		#puts "$coord_H1 $coord_H2"
		set Hmid [vecscale 0.5 [vecadd $coord_H1 $coord_H2]]

		# dipole vector
		set dipole [vecsub $Hmid $coord_O]

		# normalize 
		set dipole_norm [vecnorm $dipole]

		# Compute angle with Z-axis (in degrees)
		set cos_theta [vecdot $dipole_norm $zaxis]
		set theta [expr {acos($cos_theta) * 180.0 / acos(-1)}]

		puts $outfile "$theta"


	}

}


close $outfile

exit
