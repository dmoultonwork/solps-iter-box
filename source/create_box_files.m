function create_box_files(input)
% Create a 'baserun' and 'ref' run folder into which files will be output:
mkdir(input.baserun_dir);
mkdir(input.ref_dir);
% Create a vertical box centred on (0,0):
grid = create_vertical_grid(input);
rcentre_vertical = grid.rc(1,:);
dy_vertical = grid.dy;
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
% Output the grid (Sonnet format):
output_grid(grid,input);
% Create and output b2.boundary.parameters file:
[conpar,enpar] = output_bc(rcentre_vertical,dy_vertical,grid.iysep,input);
% Create the EIRENE arrays - contours for tria.in, segments and pump for
% block 3b:
eirene_contour = create_eirene_arrays(grid,input);
% Output the EIRENE contours to tria.in file: and block 3b file, if required:
output_tria(eirene_contour,grid,input);
% Modify the input.dat.stencil to include the EIRENE segments and pump, as
% well as the right nx,ny and albedo:
modify_inputdotdat(eirene_contour,input);
% Modify the b2ag.dat template file to have the right nx,ny:
modify_b2ag(input);
% And the same for the b2.neutrals.parameters template file:
modify_b2neutrals(input);
% Copy standard input files into baserun and ref:
copy_standard_files(input);
% Make plots:
make_plots(grid,rcentre_vertical,eirene_contour,conpar,enpar);

