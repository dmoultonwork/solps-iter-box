BOXTOP = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/'; % Full path to location of box git repository
input = defaults(); % Always required at start of input file, sets up defaults
%% File locations that must always be specified:
input.baserun_dir = [pwd,'/baserun']; % Where you want the baserun directory to go
input.ref_dir = [pwd,'/ref']; % Where you want the reference run directory to go
input.template_dir = [BOXTOP,'templates/D/']; % Location of template files
input.standard_dir = [BOXTOP,'standard_input_files/D/']; % Location of standard files that are not modified
%% Grid inputs:
input.dxg = 1E-5; % Poloidal width of guard cells (m)
input.isolate_existing_grid = true; % Decides whether to use an existing grid and isolate one of its legs
% The following are only relevant when input.isolate_existing_grid=true:
input.poloidal_section_number = 1; % From the leftmost end of the grid, this is the poloidal section to be isolated (e.g. for CDN, 1:lower inner leg, 3:upper inner leg, 4:upper outer leg, 6:lower outer).
input.existing_gridfile = [pwd,'/original_grid.sno']; % Location of existing grid whose divertor leg is to be isolated
%% BC inputs:
input.targetendright = false; % Decides the poloidal end at which the target BC is applied (true for right end, false for left end). Upstream BCs are applied to the opposite end.
input.lbccon = 0.02; % Fall off length in density boundary condition AKA lambda_n (m)
input.lbcen = 0.005; % Fall off length  in energy boundary condition AKA lambda_q (m)
input.n0 = 2.0E19; % X-point main ion density (/m3)
input.qpll0 = 0.1E9; % q|| at divertor entrance first SOL ring (W/m2)
%% EIRENE inputs for additional surfaces:
input.existing_wallfile = [pwd,'/original_wall.ogr']; % Location of existing wall file for full geometry grid
% Approximate coordinates of the bottom left, bottom right, top left and top right wall vertices that you want to be linked to the corresponding edges of the isolated grid:
input.wall_bl = [1.4,-5.2];
input.wall_br = [1.8,-5.0];
input.wall_tl = [1.2,-5.0];
input.wall_tr = [1.4,-4.8];
input.walltemp = 8.61734E-2; % Temperature of wall specified in input.dat file (eV)
input.pumpspeed = 100; % Pump speed assuming oneway Maxwellian flux with wall temp (m3/s)
input.trisize = 5.0; % Triangle size at the top of tria.in file
input.wall_scenario = 'existing'; % Sets the wall geometry shape. Choose from:
                               % 'tight': the wall is at the edges of the B2 grid. In this case the pump is placed 
                               % 'cyd': the wall is set away from the B2 grid, ready for a kink (as proposed for Cyd's PhD)
                               % 'existing': the wall is taken from an existing wall file
input.pump = [1.39,-5.2,1.44,-5.17]; % Array containing a single pump segment on each row [R1,Z1,R2,Z2]. Going from P1=(R1,Z1) to P2=(R2,Z2), surface is fully transparent on left, pumping on right.
%% Create the necessary files for SOLPS-ITER:
create_box_files(input);