function grid = kink_grid(grid_vertical,input)
    % Grid indices above the kink:
    indsabove = find(grid_vertical.zbr(:,1)>input.kink_Z);
    indsbelow = indsabove(end)+1:input.nx+2;
    % Rotate the grid below the kink point:
    origin = [grid_vertical.rtr(indsabove(end),end)+input.kink_innrad,grid_vertical.ztr(indsabove(end),end)];
    [rc_below,zc_below] = rotate(grid_vertical.rc(indsbelow,:),grid_vertical.zc(indsbelow,:),origin,input.kink_ang);
    [rtl_below,ztl_below] = rotate(grid_vertical.rtl(indsbelow,:),grid_vertical.ztl(indsbelow,:),origin,input.kink_ang);
    [rbl_below,zbl_below] = rotate(grid_vertical.rbl(indsbelow,:),grid_vertical.zbl(indsbelow,:),origin,input.kink_ang);
    [rtr_below,ztr_below] = rotate(grid_vertical.rtr(indsbelow,:),grid_vertical.ztr(indsbelow,:),origin,input.kink_ang);
    [rbr_below,zbr_below] = rotate(grid_vertical.rbr(indsbelow,:),grid_vertical.zbr(indsbelow,:),origin,input.kink_ang);
    % Fill in the region that is missing after the kink:
    rleft_kink = zeros(input.kink_nx,input.ny+3);
    zleft_kink = zeros(input.kink_nx,input.ny+3);
    rotang = linspace(0,input.kink_ang,input.kink_nx+1);
    for iy=1:input.ny+2
        [rleft_kink(1:input.kink_nx,iy),zleft_kink(1:input.kink_nx,iy)] = rotate(grid_vertical.rbr(indsabove(end),iy),grid_vertical.zbr(indsabove(end),iy),origin,rotang(1:end-1));
    end
    [rleft_kink(1:input.kink_nx,input.ny+3),zleft_kink(1:input.kink_nx,input.ny+3)] = rotate(grid_vertical.rtr(indsabove(end),iy),grid_vertical.ztr(indsabove(end),iy),origin,rotang(1:end-1));
    % Output:
    grid = struct();
    grid.rbr = [grid_vertical.rbr(indsabove,:);rleft_kink(2:end,1:end-1);rbl_below(1,:);rbr_below];
    grid.zbr = [grid_vertical.zbr(indsabove,:);zleft_kink(2:end,1:end-1);zbl_below(1,:);zbr_below];
    grid.rtr = [grid_vertical.rtr(indsabove,:);rleft_kink(2:end,2:end);rtl_below(1,:);rtr_below];
    grid.ztr = [grid_vertical.ztr(indsabove,:);zleft_kink(2:end,2:end);ztl_below(1,:);ztr_below];
    grid.rbl = [grid_vertical.rbl(indsabove,:);rleft_kink(:,1:end-1);rbl_below];
    grid.zbl = [grid_vertical.zbl(indsabove,:);zleft_kink(:,1:end-1);zbl_below];
    grid.rtl = [grid_vertical.rtl(indsabove,:);rleft_kink(:,2:end);rtl_below];
    grid.ztl = [grid_vertical.ztl(indsabove,:);zleft_kink(:,2:end);ztl_below];
    indskink = indsabove(end)+1:indsabove(end)+1+input.kink_nx;
    grid.rc = [grid_vertical.rc(indsabove,:);0.25*(grid.rbl(indskink,:)+grid.rbr(indskink,:)+grid.rtl(indskink,:)+grid.rtr(indskink,:));rc_below];
    grid.zc = [grid_vertical.zc(indsabove,:);0.25*(grid.zbl(indskink,:)+grid.zbr(indskink,:)+grid.ztl(indskink,:)+grid.ztr(indskink,:));zc_below];
end