classdef contour_class
    properties
        tria % Coordinates to go into each zone in tria.in
        seg % Coordinates to go into EIRENE wall segments defined in block 3b of input.dat
        pump % Coordinates to go into EIRNE pump segments defined in block 3b of input.dat
        limpos_bl % Index of additional surface to be fixed to bottom left of B2.5 grid
        limpos_tl % Index of additional surface to be fixed to top left of B2.5 grid
        limpos_br % Index of additional surface to be fixed to bottom right of B2.5 grid
        limpos_tr % Index of additional surface to be fixed to top right of B2.5 grid
    end
end