%.stl: %.scad
	openscad -o "$@" "$<"