# Chamfering an STL File

This is a process for chamfering corners of an STL object that is in relevant
part a right prism.

1. Take a projection of the object, with `cut = true`.
2. Export the projection as an SVG file.
3. Run `cvt-svg-path.rb` to convert the SVG into a path. Note that the path will
   be flipped upside down, probably because of a difference in coordinate
   systems between SVG and OpenSCAD.
4. Construct a chamfer mask, using `offset_sweep`, and subtract it from the
   original object.
