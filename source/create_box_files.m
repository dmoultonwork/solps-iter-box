function create_box_files(input)
% Create a 'baserun' and 'ref' run folder into which files will be output:
mkdir(input.baserun_dir);
mkdir(input.ref_dir);
% Create a vertical box:
grid_norotation = create_vertical_grid(input);
% Kink if required:
if input.makekink
    grid_norotation = kink_grid(grid_norotation,input);
end
% Rotate about (R0,Z0) as required:
grid_rotated = rotate_grid(grid_norotation,input);
% Add magnetic field to rotated grid:
grid_rotated = add_mag_field(grid_rotated,input);
% Output the grid (Sonnet format):
output_grid(grid_rotated,input);
% Create and output b2.boundary.parameters file:
[conpar,enpar] = output_bc(grid_norotation,input);
% Create the EIRENE arrays - contours for tria.in, segments and pump for
% block 3b:
eirene_contour = create_eirene_arrays(grid_rotated,input);
% Output the EIRENE contours to tria.in file: and block 3b file, if required:
output_tria(eirene_contour,grid_rotated,input);
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
make_plots(grid_rotated,grid_norotation,eirene_contour,conpar,enpar,input);

