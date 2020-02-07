#!/bin/tclsh
# set echo on for debugging
echo on

# need psfgen module and topology
package require psfgen
# load structures
resetpsf

readpsf  faddi019A.psf
coordpdb faddi019A.pdb


readpsf  faddi019_test.psf
coordpdb faddi019_test.pdb
# write temporary structure
set temp "faddi019_2mer"
writepsf $temp.psf
writepdb $temp.pdb

