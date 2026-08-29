ifeq (, $(shell which /snap/bin/openscad-nightly))
    OPENSCAD=openscad
else
    OPENSCAD=/snap/bin/openscad-nightly
endif

%.stl: %.scad
	$(OPENSCAD) --backend manifold -o "$@" "$<"
