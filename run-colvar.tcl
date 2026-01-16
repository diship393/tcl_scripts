mol new protein_ref.psf
mol addfile qwrapped_protein.dcd waitfor all

# source: https://www.ks.uiuc.edu/Research/vmd/vmd-1.9.4/ug/node224.html

# Activate the module on the current VMD molecule
cv molid top
# Load a Colvars config file
cv configfile spinangle_and_tilt_colvar.dat
set out [open "spinangle_and_tilt_colvar.colvars.traj" "w"]
# Write the labels to the file
puts -nonewline ${out} [cv printframelabels]
for { set fr 0 } { ${fr} < [molinfo top get numframes] } { incr fr } {
  # Point Colvars to this trajectory frame
  cv frame ${fr}
  # Recompute variables and biases (required in VMD)
  cv update
  # Print variables and biases to the file
  puts -nonewline ${out} [cv printframe]
}
close ${out}
