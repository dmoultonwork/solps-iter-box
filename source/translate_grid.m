function grid_out = translate_grid(grid_in,R0,Z0)
    grid_out = grid_in;
    
    DR = R0-grid_in.rbr(1,grid_in.iysep);
    DZ = Z0-grid_in.zbr(1,grid_in.iysep);
    grid_out.rc = grid_in.rc+DR;
    grid_out.rtl = grid_in.rtl+DR;
    grid_out.rbl = grid_in.rbl+DR;
    grid_out.rtr = grid_in.rtr+DR;
    grid_out.rbr = grid_in.rbr+DR;
    grid_out.zc = grid_in.zc+DZ;
    grid_out.ztl = grid_in.ztl+DZ;
    grid_out.zbl = grid_in.zbl+DZ;
    grid_out.ztr = grid_in.ztr+DZ;
    grid_out.zbr = grid_in.zbr+DZ;
end