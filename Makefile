%.stl: %.scad
	openscad -o "$@" "$<"
