input = struct();
%% File locations:
input.baserun_dir = [pwd,'/baserun']; % Where you want the baserun directory to go
input.ref_dir = [pwd,'/ref']; % Where you want the reference run directory to go
input.template_dir = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/templates/D/'; % Location of template files
input.standard_dir = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/standard_input_files/D/'; % Location of standard files that are not modified
%% Grid inputs:
% Magnetic field:
input.RBtor = 4; % Bt = RBtor/R;
input.FR0 = 0.05; % Bp = RBtor*FR0/R;
input.nx = 200; % Number of non-guard cells in poloidal (x) direction
input.ny = 40; % Number of non-guard cells in radial (y) direction
input.nyp = 0; % Number of extra PFR cells in y direction
input.R0 = 2; % Major radius of X-point
input.Z0 = 0; % Vertical coordinate of X-point
input.dx = 1; %1.53; % Poloidal length from X-point to target separatrix
input.dy = 0.25; % Radial width of grid
input.dxg = 0.00001; % Poloidal width of guard cells
input.dyg = 0.00001; % Radial width of guard cells
input.ang = 0.01; % Rotation angle (degrees)
input.lx = 0.22; % Exponential poloidal compression length towards the target
input.ly = 0.33; % Exponential radial compression width towards the separatrix
input.pfrfrac = 0.4; % Separatrix is positioned a distance pfrfrac*dy along the radial coordinate
input.makekink = false; % Decides whether to make a kink in the box
input.kink_Z = -1; % Vertical coordinate of kink
input.kink_ang = 45; % Angle induced by kink
input.kink_innrad = 0.1; % Inner radius of kink (from maximal radial edge of grid)
input.kink_nx = 8; % Number of extra grid rows to account for the kink
%% BC inputs:
input.lbccon = 0.02; % Fall off length in density boundary condition AKA lambda_n (m)
input.lbcen = 0.005; % Fall off length  in energy boundary condition AKA lambda_q (m)
input.n0 = 5.0E19; % X-point main ion density (/m3)
input.powerin = 5E7; % Total electron power (=ion power) going into this one leg (W) (Note Psep ~ 4*powerin)
%% EIRENE inputs for additional surfaces:
input.walltemp = 8.61734E-2; % Temperature of wall speicified in input.dat file (eV)
input.pumpspeed = 100; % Pump speed assuming oneway Maxwellian flux with wall temp (m3/s)
input.trisize = 5.0; % Triangle size at the top of tria.in file
input.wall_scenario = 'tight'; % Sets the wall geometry shape. Choose from:
                               % 'tight': the wall is at the edges of the
                               % B2 grid. In this case the pump is placed 
                               % 'cyd': the wall is set away from the B2 grid, ready for a kink (as proposed for Cyd's PhD)
% The following inputs are required for wall_scenario 'tight':
input.pumplength = 0.1; % Length of the pumping surface, placed at the top right of the grid
% The following inputs are required for wall_scenario 'cyd':
input.bottomwall = -1.48; % Z location of bottom wall (m)
input.pumpprotect = 0.1; % Fraction of radial extent of box at which to place a wall structure to protect the pump
input.pumpthroat = 0.05; % Length of the width open to the pump (relative to the radial extent of the box)

create_box_files(input);