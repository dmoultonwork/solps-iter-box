function grid_out = rotate_grid(grid_in,angle)
    grid_out = grid_in;
    [grid_out.rc,grid_out.zc] = rotate(grid_in.rc,grid_in.zc,angle);
    [grid_out.rtl,grid_out.ztl] = rotate(grid_in.rtl,grid_in.ztl,angle);
    [grid_out.rbl,grid_out.zbl] = rotate(grid_in.rbl,grid_in.zbl,angle);
    [grid_out.rtr,grid_out.ztr] = rotate(grid_in.rtr,grid_in.ztr,angle);
    [grid_out.rbr,grid_out.zbr] = rotate(grid_in.rbr,grid_in.zbr,angle);
end