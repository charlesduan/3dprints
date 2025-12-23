function resolve_point(i, points) = (
    is_list(points[i]) ? points[i] : resolve_point(i + points[i], points)
);

// Given a list of points and a series of children, connects each child
// translated to each sequential pair of points, and performs a hull between
// them.
module seq_hull(points) {
    for (i = [ 0 : 1 : len(points) - 2]) {
        if (is_list(points[i + 1])) {
            for (c = [ 0 : 1 : $children - 1 ]) {
                hull() {
                    translate(resolve_point(i, points)) children(c);
                    translate(points[i + 1]) children(c);
                }
            }
        }
    }
}


