function grid = add_mag_field(grid,input)
    grid.Bt = input.RBtor./grid.rc; % toroidal field
    grid.Bp = input.RBtor*input.FR0./grid.rc./grid.PFX; % poloidal field
end