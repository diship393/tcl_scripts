# create psf and pdb for crystal structure (obtained from cif file)
# lammps output file


# source : https://sites.google.com/site/akohlmey/software/topotools/various-odds-ends#h.cpmq1h3sa02l

# reading input
# change atom_style based on lmp input file: here charge atom_style is used

package require topotools

# uncomment following lines if processing lammps output file
# topo readlammpsdata data.final_frame charge

# guessing atom properties
#topo guessatom element mass
#topo guessatom name element
#topo guessatom radius element

# for FE atoms
set sel1 [atomselect top "name FE"]
$sel1 set type FE
$sel1 set resname HEM

# for O atoms
set sel2 [atomselect top "name O"]
$sel2 set type O
$sel2 set resname HEM

# set residue ID to a 1-based index.
set resid {}
foreach r [$sel1 get residue] {incr r; lappend resid $r}
$sel1 set resid $resid

set resid {}
foreach r [$sel2 get residue] {incr r; lappend resid $r}
$sel2 set resid $resid

mol bondsrecalc top
topo retypebonds
topo bondtypenames
topo guessangles
mol reanalyze top
animate write psf hema.psf
animate write pdb hema.pdb
