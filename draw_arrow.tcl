proc vmd_draw_arrow {mol start end} {
    # an arrow is made of a cylinder and a cone
    set middle [vecadd $start [vecscale 0.9 [vecsub $end $start]]]
    graphics $mol cylinder $start $middle radius 0.15
    graphics $mol cone $middle $end radius 0.25
}

tkcon font Courier 15
draw arrow {5.10390075510794 12.7061744043397 4.56473392775736} {0.260772016770653 -40.5579518079497 14.7524278543667}
