BOXTOP = '/home/david/Dropbox/CCFE/solps-iter/scripts.local/box/'; % Full path to location of box git repository
input = defaults(); % Always required at start of input file, sets up defaults
%% File locations that must always be specified:
input.baserun_dir = [pwd,'/baserun']; % Where you want the baserun directory to go
input.ref_dir = [pwd,'/ref']; % Where you want the reference run directory to go
input.template_dir = [BOXTOP,'templates/D/']; % Location of template files
input.standard_dir = [BOXTOP,'standard_input_files/D/']; % Location of standard files that are not modified

input.ang = pi/2; % Rotation angle (radians)
input.n0 = 1.8E19; % Density at divertor entrance first SOL ring (/m3)
input.qpll0 = 5E8;

create_box_files(input);