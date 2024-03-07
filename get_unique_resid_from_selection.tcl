# DFG region 
#

set sel [atomselect top "same residue as (within 5 of (residue 162 163 164 and noh) and noh) and noh"]
set s1 [$sel get  resid]
set s2 [lsort -unique $s1]
puts "for DFG region residue list : $s2"


# alpha-C region
#
set sel [atomselect top "same residue as (within 5 of ((residue 40 to 63) and noh) and noh) and noh"]
set s1 [$sel get  resid]
set s2 [lsort -unique $s1]
puts "for alpha-C region residue list : $s2"

exit
