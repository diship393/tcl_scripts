mol new faddi019_2mer.psf
mol addfile faddi019_2mer.pdb
package require solvate 
solvate faddi019_2mer.psf faddi019_2mer.pdb -t 40 -o faddi019_2mer.temp

set sel [atomselect top all]
set netcharge [eval "vecadd [$sel get charge]"]
$sel delete

package require psfgen
package require autoionize
autoionize -psf faddi019_2mer.temp.psf -pdb faddi019_2mer.temp.pdb -sc 0.15 -o faddi019_2mer.ion
quit
