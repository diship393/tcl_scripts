# Load the psfgen package
package require psfgen

# Reset psf just in case
resetpsf

# Read system using PSFGEN commands
readpsf  file.psf
coordpdb file.pdb

# Load system to VMD
mol load psf file.psf pdb file.pdb

# Do some VMD tasks
set sel [atomselect top protein]
measure center $sel
measure minmax $sel

# Write the system to .psf/pdb using PSFGEN commands
writepsf all.psf
writepdb all.pdb

# To modify the system, one should use PSFGEN commands.
# Example: to remove water molecules
  # Select the water 
  set water [atomselect top water] 

  # Using PSFGEN commands, delete the selected atoms.
  foreach segid [$water get segid] resid [$water get resid] {
    delatom $segid $resid
  }

# Write molecule without water, using PSFGEN commands
writepsf nowater.psf
writepdb nowater.pdb

quit

