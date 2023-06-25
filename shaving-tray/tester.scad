// Test hexagon for fitting onto stem.
//
module tester_hexagon() {
    back(3 * outer_stem_diam) {
        difference() {
            linear_sweep(
                region = hexagon(od = outer_stem_diam),
                h = 10,
                anchor = BOTTOM
            );
            down(eps) linear_sweep(
                region = hexagon(od = stem_diam + stem_slop),
                h = 10 + 2 * eps,
                anchor = BOTTOM
            );
        }
    }
}

tester();
