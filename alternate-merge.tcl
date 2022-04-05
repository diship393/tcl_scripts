# for merging 2 molecules
# before running the script load both molecules' psf and pdb files in vmd 
# reuires at least vmd1.9.4

set sellist {}
# selection 1
lappend sellist [atomselect 0 all]
# selection 2
lappend sellist [atomselect 1 all]

llength $sellist
mol fromsels $sellist

# This bypasses any disk I/O and builds a new VMD molecule from a list of
# VMD atom selections from existing molecule(s).
# It can be substantially faster than other methods if the structures you've got 
# loaded in VMD contain everything you want and you just need to put them 
# together in a single molecule.
#

set a [atomselect top all]
$a writepsf merge.psf
$a writepdb merge.pdb
