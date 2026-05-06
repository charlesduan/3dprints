%.stl: %.scad
	openscad --backend manifold -o "$@" "$<"
