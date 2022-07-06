BOXTOP = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/'; % Full path to location of box git repository
input = defaults(); % Always required at start of input file, sets up defaults
%% File locations that must always be specified:
input.baserun_dir = [pwd,'/baserun']; % Where you want the baserun directory to go
input.ref_dir = [pwd,'/ref']; % Where you want the reference run directory to go
input.template_dir = [pwd,'/templates/']; % Location of template files
input.standard_dir = [pwd,'/standard_input_files/']; % Location of standard files that are not modified
%% Grid inputs:
input.dxg = 1E-5; % Poloidal width of guard cells (m)
input.isolate_existing_grid = true; % Decides whether to use an existing grid and isolate one of its legs
% The following are only relevant when input.isolate_existing_grid=true:
input.poloidal_section_number = 6; % From the leftmost end of the grid, this is the poloidal section to be isolated (e.g. for CDN, 1:lower inner leg, 3:upper inner leg, 4:upper outer leg, 6:lower outer).
input.existing_gridfile = [pwd,'/mastu_sxd_45456_445ms.v002.sno']; % Location of existing grid whose divertor leg is to be isolated
%% BC inputs:
input.targetendright = true; % Decides the poloidal end at which the target BC is applied (true for right end, false for left end). Upstream BCs are applied to the opposite end.
input.lbccon = 0.02; % Fall off length in density boundary condition AKA lambda_n (m)
input.lbcen = 0.007; % Fall off length  in energy boundary condition AKA lambda_q (m)
input.n0 = 0.3E19; % X-point main ion density (/m3)
input.qepll0 = 12E6; % q||e at divertor entrance first SOL ring, mapped to midplane (mapping only affects actual q||e at the entrance when isolating an existing grid) (W/m2)
input.qipll0 = 6E6; % the same as the above for the ion (22/10/2020, Ryoko)
input.pfrbcmom = 1; % BCMOM for D+ ions for the PFR (see solps-iter manual). Corresponding MOMPAR is always 0, so pfrbcmom==1 gives zero velocity, pfrbcmom==2 gives zero velocity gradient.
%% EIRENE inputs for additional surfaces:
input.existing_wallfile = [pwd,'/mastu_wall_50mm_unique.ogr']; % Location of existing wall file for full geometry grid
% Approximate coordinates of the bottom left, bottom right, top left and top right wall vertices (given in the .ogr file) that will be fixed to the corresponding edges of the isolated grid:
input.wall_bl = [0.495,-1.47];
input.wall_br = [1.09,-2.06];
input.wall_tl = [0.93,-1.27];
input.wall_tr = [1.69,-1.72];
input.walltemp = 2.58500E-02; % Temperature of wall specified in input.dat file (eV)
input.pumpspeed = 100; % Pump speed assuming oneway Maxwellian flux with wall temp (m3/s)
input.trisize = 2.5; % Triangle size at the top of tria.in file
input.wall_scenario = 'existing'; % Sets the wall geometry shape. Choose from:
                               % 'tight': the wall is at the edges of the B2 grid. In this case the pump is placed 
                               % 'cyd': the wall is set away from the B2 grid, ready for a kink (as proposed for Cyd's PhD)
                               % 'existing': the wall is taken from an existing wall file
input.pump = [1.39,5.2,1.44,5.17]; % Array containing a single pump segment on each row [R1,Z1,R2,Z2]. Going from P1=(R1,Z1) to P2=(R2,Z2), surface is fully transparent on left, pumping on right.
%% Create the necessary files for SOLPS-ITER:
create_box_files(input);