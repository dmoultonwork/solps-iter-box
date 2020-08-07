function input = defaults()
%% File locations:
input.baserun_dir = [pwd,'/baserun']; % Where you want the baserun directory to go
input.ref_dir = [pwd,'/ref']; % Where you want the reference run directory to go
input.template_dir = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/templates/D/'; % Location of template files
input.standard_dir = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/standard_input_files/D/'; % Location of standard files that are not modified
%% Grid inputs:
input.isolate_existing_grid = false; % Decides whether to use an existing grid and isolate one of its legs
% Magnetic field:
input.RBtor = 0.5; % Bt = RBtor/R;
input.FR0 = 0.05; % Bp = RBtor*FR0/R;
input.nx = 200; % Number of non-guard cells in poloidal (x) direction
input.ny = 40; % Number of non-guard cells in radial (y) direction
input.nyp = 0; % Number of extra PFR cells in y direction
input.R0 = 1; % Major radius of X-point
input.Z0 = 0; % Vertical coordinate of X-point
input.dx = 1; %1.53; % Poloidal length from X-point to target separatrix
input.dy = 0.25; % Radial width of grid
input.dxg = 0.00001; % Poloidal width of guard cells
input.dyg = 0.00001; % Radial width of guard cells
input.ang = pi/4; % Rotation angle (radians)
input.lx = 0.22; % Exponential poloidal compression length towards the target
input.ly = 0.33; % Exponential radial compression width towards the separatrix
input.pfrfrac = 0.4; % Separatrix is positioned a distance pfrfrac*dy along the radial coordinate
input.makekink = false; % Decides whether to make a kink in the box
input.kink_Z = -0.5; % Vertical coordinate of kink before box is rotated
input.kink_ang = -60; % Angle induced by kink (degrees)
input.kink_innrad = 0.1; % Inner radius of kink (from radial edge of grid)
input.kink_nx = 30; % Number of extra grid rows to account for the kink
input.makebulgesqueeze = false; % Decides whether to make bulges and/or squeezes
input.bulge_position = [-0.3,0.3]; % Poloidal position of the bulge, relative to the poloidal mid-point
input.bulge_magnitude = [0.05,0.05]; % Size of the bulge
input.bulge_radius = [0.3,0.3]; % Distance of null points from bulge
input.squeeze_position = [0]; % Poloidal position of the squeeze, relative to the poloidal mid-point
input.squeeze_magnitude = [0.03]; % Size of the squeeze
input.squeeze_radius = [0.3]; % Distance of null points from squeeze
%% BC inputs:
input.PFX_mp = 10; % Constant poloidal flux expansion from midplane to x-point
input.lbccon = 0.006; % Fall off length in density boundary condition AKA lambda_n, mapped to midplane (m)
input.lbcen = 0.003; % Fall off length  in energy boundary condition AKA lambda_q, mapped to midplane (m)
input.n0 = 1.0E19; % Density at divertor entrance first SOL ring (/m3)
input.qpll0 = 0.1E9; % q|| at divertor entrance first SOL ring, mapped to midplane (mapping only affects actual q|| at the entrance when isolating an existing grid) (W/m2)
%% EIRENE inputs for additional surfaces:
input.walltemp = 8.61734E-2; % Temperature of wall speicified in input.dat file (eV)
input.pumpspeed = 100; % Pump speed assuming oneway Maxwellian flux with wall temp (m3/s)
input.trisize = 5.0; % Triangle size at the top of tria.in file
input.wall_scenario = 'cyd'; % Sets the wall geometry shape. Choose from:
                               % 'tight': the wall is at the edges of the
                               % B2 grid. In this case the pump is placed 
                               % 'cyd': the wall is set away from the B2 grid, ready for a kink (as proposed for Cyd's PhD)
% The following inputs are required for wall_scenario 'tight':
input.pumplength = 0.1; % Length of the pumping surface, placed at the top right of the grid
% The following inputs are required for wall_scenario 'cyd':
% input.bottomwall = -0.8; % Z location of bottom wall (m)
input.pumpprotect = 0.1; % Fraction of radial extent of box at which to place a wall structure to protect the pump
input.pumpthroat = 0.05; % Length of the width open to the pump (relative to the radial extent of the box)