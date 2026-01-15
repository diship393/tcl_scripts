# by po chao

mol load psf $psf pdb $pdb
foreach dcd [glob *.dcd] {
  mol addfile $dcd type dcd waitfor all
  set nf [molinfo top get numframes]
  qunwrap sel $sel
  qwrap center $sel
  animate write dcd first 1 end $nf sel $sel waitfor all
  animate delete beg 0 end [expr $nf - 2]
}
