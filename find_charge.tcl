set sel [atomselect top all]
set netcharge [eval "vecadd [$sel get charge]"]
puts $netcharge
$sel delete
