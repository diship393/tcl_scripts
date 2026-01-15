# https://www.ks.uiuc.edu/Research/vmd/script_library/scripts/rotation_movie/

proc make_rotation_movie_files {} {
	set frame 0
	for {set i 0} {$i < 360} {incr i 20} {
		set filename snap.[format "%04d" $frame].rgb
		render snapshot $filename
		incr frame
		rotate y by 20
	}
}
