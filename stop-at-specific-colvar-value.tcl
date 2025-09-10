set terminate false

set nSteps 1000

set threshold 10.0

while { ! $terminate } {
    set cv_value [cv colvar cvName value]
    if [$cv_value > $threshold] {
        set terminate true          ;# terminate depending on CV
    }
    run $nSteps                     ;# advance simulation
}

