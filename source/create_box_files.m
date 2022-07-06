function create_box_files(input)
% Create a 'baserun' and 'ref' run folder into which files will be output:
mkdir(input.baserun_dir);
mkdir(input.ref_dir);
% Either (1) create an artificial box grid according to user requirements
%        (2) isolate a divertor leg from an existing full geometry grid
if ~input.isolate_existing_grid
    % Create a vertical box centred on (0,0):
    grid = create_vertical_grid(input);
    % Bulge-squeeze if required:
    if input.makebulgesqueeze
        grid = bulgesqueeze_grid(grid,input);
    end
    % Kink if required:
    if input.makekink
        grid = kink_grid(grid,input);
    end
    % Rotate as required:
    grid = rotate_grid(grid,input.ang);
    % Translate as required:
    grid = translate_grid(grid,input.R0,input.Z0);
    % Add magnetic field to rotated grid:
    grid = add_mag_field(grid,input);
else
    grid = isolate_leg(input);
end
% Create and output b2.boundary.parameters file:
[conpar,qpll_x_mp] = output_bc(grid,input);
% Output the grid (Sonnet format):
output_grid(grid,input.baserun_dir);
% Create the EIRENE arrays - contours for tria.in, segments and pump for
% block 3b:
eirene_contour = create_eirene_arrays(grid,input); %STILL NEED TO PUT IN PUMP!
% Output the EIRENE contours to tria.in file:
output_tria(eirene_contour,grid,input);
% Modify the input.dat.stencil to include the EIRENE segments and pump, as
% well as the right nx,ny and albedo and block 3b file, if required::
modify_inputdotdat(eirene_contour,grid,input);
% Modify the b2ag.dat template file to have the right nx,ny:
modify_b2ag(grid,input);
% And the same for the b2.neutrals.parameters template file:
modify_b2neutrals(grid,input);
% Put the right jsep into b2mn.dat:
modify_b2mn(grid,input);
% Modify the param.dg file to output wall loading datas
if (input.write_param)
    modify_paramdotdg(eirene_contour,grid,input);
end
% Copy standard input files into baserun and ref:
copy_standard_files(input);
% Make plots:
make_plots(grid,eirene_contour,conpar,qpll_x_mp,input);