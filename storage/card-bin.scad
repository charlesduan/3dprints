/*
 * A box for storing credit cards and other cards of similar form factor, with
 * divider tabs.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// Card dimensions.
card_d = [ 85.6, 53.98 ];

// Box shell thickness.
shell = 0.6 * 3;

// Box angle. 90 would be straight horizontal sides; less makes the box flare
// outward toward the top (better for viewing cards).
side_angle = 70;

// Box length (including any outward flare).
box_depth = 170;

// Amount of cards to reveal over the top edge of the box.
top_reveal = 10;

// Amount of horizontal wiggle to allow the cards (total, not per side).
card_slop = 2;

// Rounding of the inside vertical edges. Should be less than card_slop / 2.
edge_round = 0.5;

// Tab grooves. x is the width of the groove (no more than card_d.x / 2), y the
// back-and-forth sliding distance, z the space between grooves.
tab_groove_d = [ 15, 1.5, 3 ];

// Slop for tab grooves (total width, not just each side)
tab_groove_slop = 2;

// Height that the tab groove insertion part extends.
tab_groove_height = 1.5;

// Dimensions of the tab (just the flap part). x is the base width of the tab, y
// the height of the tab, z the thickness (affects the whole tab).
tab_d = [ 35, 6, 0.75 ];

// Angle of the side slopes of the tab flap.
tab_angle = 45;

// Rounding of the top part of the tab flap.
tab_round = 5;

// Amount to retain of sides of tab (for determining interior cutout).
tab_side_keep = 12;

eps = 0.01;


// Each angled side forms a right triangle of angle side_angle.
//
// For the inside of the box, the height is card.y - top_reveal.
//
// The depth of the inside bottom is the width of the inside top minus two times
// the inside triangle width.
function inside_bot_depth() = box_depth - 2 * shell - 2 * opp_ang_to_adj(
    card_d.y - top_reveal, side_angle
);

// For the outside of the box, the height is card.y - top_reveal + shell.
//
// The outside bottom depth is the width of the outside top minus two times the
// outside triangle width.
function outside_bot_depth() = box_depth - 2 * opp_ang_to_adj(
    card_d.y - top_reveal + shell, side_angle
);

// The inside width is the card width plus the card slop.
function inside_width() = card_d.x + card_slop;
function outside_width() = inside_width() + 2 * shell;

// For the tab grooves, there are 2 grooves per horizontal line with equal
// spacing around and between them. Thus, the "rails" (the spaces between the
// grooves) are (inside_width() - 2 * tab_groove_d.x) / 3 in width. This
// function computes how far from the center Y axis the center of each groove
// is.
function groove_x_center() = tab_groove_d.x / 2 + (
    inside_width() - 2 * tab_groove_d.x
) / 6;

difference() {

    // Outside shell
    prismoid(
        size2 = [ outside_width(), box_depth ],
        xang = 90,
        yang = 180 - side_angle,
        h = card_d.y - top_reveal + shell,
        rounding = edge_round + shell,
        anchor = BOTTOM
    );

    // Inside cutout
    up(shell) prismoid(
        size1 = [ inside_width(), inside_bot_depth() ],
        xang = 90,
        yang = 180 - side_angle,
        h = card_d.y - top_reveal + eps,
        rounding = edge_round,
        anchor = BOTTOM
    );

    //
    // The space from one groove to the next.
    //
    groove_spacing = tab_groove_d.y + tab_groove_d.z;
    //
    // Tab grooves are placed every groove_spacing units. The maximum distance
    // available for grooves is inside_bot_depth() - tab_groove_d.y. Thus, this
    // calculates the number of grooves that can be placed.
    //
    groove_num = floor(
        (inside_bot_depth() - tab_groove_d.y) / groove_spacing
    );
    ycopies(spacing = groove_spacing, n = groove_num) {
        xcopies([ -groove_x_center(), groove_x_center() ]) {
            down(eps) cuboid(
                [ tab_groove_d.x, tab_groove_d.y, shell + 2 * eps ],
                anchor = BOTTOM
            );
        }
    }
}



// Makes the top edge of the tab.
function tab_top() = back(card_d.y, round_corners(
    [
        [ 0, 0 ],
        [ opp_ang_to_adj(tab_d.y, tab_angle), tab_d.y ],
        [ tab_d.x - opp_ang_to_adj(tab_d.y, tab_angle), tab_d.y ],
        [ tab_d.x, 0 ],
        [ card_d.x, 0 ]
    ],
    r = tab_round,
    closed = false
));

module tab_body() {
    linear_extrude(tab_d.z) {
        difference() {
            union() {
                // The tab body
                left(card_d.x / 2) polygon(
                    concat(tab_top(), [ [ card_d.x, 0 ], [ 0, 0 ] ])
                );

                // The tab groove flanges
                back(eps) xcopies([ -groove_x_center(), groove_x_center() ]) {
                    rect(
                        [
                            tab_groove_d.x - tab_groove_slop,
                            tab_groove_height + eps
                        ],
                        rounding = [ 0, 0, 1, 1 ] * tab_groove_height / 2,
                        anchor = BACK
                    );
                }
            }
            back(tab_side_keep) rect(
                card_d - [ 2, 2 ] * tab_side_keep,
                anchor = FRONT
            );
        }
    }
}

left(outside_width() + 20) tab_body();
