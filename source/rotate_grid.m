function grid_out = rotate_grid(grid_in,input)
    [grid_out.rc,grid_out.zc] = rotate(grid_in.rc,grid_in.zc,[input.R0,input.Z0],input.ang);
    [grid_out.rtl,grid_out.ztl] = rotate(grid_in.rtl,grid_in.ztl,[input.R0,input.Z0],input.ang);
    [grid_out.rbl,grid_out.zbl] = rotate(grid_in.rbl,grid_in.zbl,[input.R0,input.Z0],input.ang);
    [grid_out.rtr,grid_out.ztr] = rotate(grid_in.rtr,grid_in.ztr,[input.R0,input.Z0],input.ang);
    [grid_out.rbr,grid_out.zbr] = rotate(grid_in.rbr,grid_in.zbr,[input.R0,input.Z0],input.ang);
end