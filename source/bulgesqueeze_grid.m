function grid_out = bulgesqueeze_grid(grid_vertical,input)
    
grid_out = grid_vertical;

% Find the length and width of a non-bulgesqueezed grid which, after the 
% bulgesqueeze mapping, will have the desired SOL width (at the left end of the
% grid) and length:
p_init = [input.dx,(1-input.pfrfrac)*input.dy]; % initial guess (poloidal length, radial width of SOL);
dxSOL_target = input.dx;
dySOL_target = (1-input.pfrfrac)*input.dy;
p_min = fminsearch(@(p) minfunc(p,dxSOL_target,dySOL_target,...
                                input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius),p_init);
% Apply the bulgesqueeze to the vertical grid after uniformly stretching it so 
% that the bulged grid has the required width and length and rotating it by pi/2.
% First uniformly stretch:
grid_out.rbl = grid_vertical.rbl*p_min(2)/dySOL_target;
grid_out.rbr = grid_vertical.rbr*p_min(2)/dySOL_target;
grid_out.rtl = grid_vertical.rtl*p_min(2)/dySOL_target;
grid_out.rtr = grid_vertical.rtr*p_min(2)/dySOL_target;
grid_out.rc = grid_vertical.rc*p_min(2)/dySOL_target;
grid_out.zbl = grid_vertical.zbl*p_min(1)/dxSOL_target;
grid_out.zbr = grid_vertical.zbr*p_min(1)/dxSOL_target;
grid_out.ztl = grid_vertical.ztl*p_min(1)/dxSOL_target;
grid_out.ztr = grid_vertical.ztr*p_min(1)/dxSOL_target;
grid_out.zc = grid_vertical.zc*p_min(1)/dxSOL_target;
% Then rotate by pi/2:
[grid_out.rbl,grid_out.zbl] = rotate(grid_out.rbl,grid_out.zbl,pi/2);
[grid_out.rbr,grid_out.zbr] = rotate(grid_out.rbr,grid_out.zbr,pi/2);
[grid_out.rtl,grid_out.ztl] = rotate(grid_out.rtl,grid_out.ztl,pi/2);
[grid_out.rtr,grid_out.ztr] = rotate(grid_out.rtr,grid_out.ztr,pi/2);
[grid_out.rc,grid_out.zc] = rotate(grid_out.rc,grid_out.zc,pi/2);
% Then bulgesqueeze:
rc_original = grid_out.rc;
zc_original = grid_out.zc;
[grid_out.rbl,grid_out.zbl] = bulgesqueeze(grid_out.rbl,grid_out.zbl,...
                                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[grid_out.rbr,grid_out.zbr] = bulgesqueeze(grid_out.rbr,grid_out.zbr,...
                                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[grid_out.rtl,grid_out.ztl] = bulgesqueeze(grid_out.rtl,grid_out.ztl,...
                                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[grid_out.rtr,grid_out.ztr] = bulgesqueeze(grid_out.rtr,grid_out.ztr,...
                                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[grid_out.rc,grid_out.zc,original] = bulgesqueeze(grid_out.rc,grid_out.zc,...
                                                  input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                                                  input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
% Set guard cell centres as average of vertices:
grid_out.rc(1:end,1) = 0.25*(grid_out.rbl(1:end,1)+grid_out.rtl(1:end,1)+grid_out.rbr(1:end,1)+grid_out.rtr(1:end,1));
grid_out.rc(1:end,end) = 0.25*(grid_out.rbl(1:end,end)+grid_out.rtl(1:end,end)+grid_out.rbr(1:end,end)+grid_out.rtr(1:end,end));
grid_out.rc(1,1:end) = 0.25*(grid_out.rbl(1,1:end)+grid_out.rtl(1,1:end)+grid_out.rbr(1,1:end)+grid_out.rtr(1,1:end));
grid_out.rc(end,1:end) = 0.25*(grid_out.rbl(end,1:end)+grid_out.rtl(end,1:end)+grid_out.rbr(end,1:end)+grid_out.rtr(end,1:end));
grid_out.zc(1:end,1) = 0.25*(grid_out.zbl(1:end,1)+grid_out.ztl(1:end,1)+grid_out.zbr(1:end,1)+grid_out.ztr(1:end,1));
grid_out.zc(1:end,end) = 0.25*(grid_out.zbl(1:end,end)+grid_out.ztl(1:end,end)+grid_out.zbr(1:end,end)+grid_out.ztr(1:end,end));
grid_out.zc(1,1:end) = 0.25*(grid_out.zbl(1,1:end)+grid_out.ztl(1,1:end)+grid_out.zbr(1,1:end)+grid_out.ztr(1,1:end));
grid_out.zc(end,1:end) = 0.25*(grid_out.zbl(end,1:end)+grid_out.ztl(end,1:end)+grid_out.zbr(end,1:end)+grid_out.ztr(end,1:end));
% Warn if there are any remaining centres that lie outside the cell vertices:
for ix=1:input.nx+2
    for iy=1:input.ny+input.nyp
        if ~inpolygon(grid_out.rc(ix,iy),...
                      grid_out.zc(ix,iy),...
                      [grid_out.rbl(ix,iy),grid_out.rtl(ix,iy),grid_out.rtr(ix,iy),grid_out.rbr(ix,iy)],...
                      [grid_out.zbl(ix,iy),grid_out.ztl(ix,iy),grid_out.ztr(ix,iy),grid_out.zbr(ix,iy)]);
            warning('Centre of cell (ix,iy)=(%d,%d) lies outside of the cell vertices',ix,iy);
        end
    end
end
% Calculate the radial width (dy) of each cell:
[~,~,plus] = bulgesqueeze(rc_original,zc_original+eps*1e7,...
                          input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                          input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[~,~,minus] = bulgesqueeze(rc_original,zc_original-eps*1e7,...
                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
grid_out.PFX = 0.5.*(abs(plus-original)+abs(minus-original))/(eps*1e7);
grid_out.dy = grid_out.PFX.*grid_vertical.dy;
% Calculate the poloidal length (dx) of each cell:
[~,~,plus] = bulgesqueeze(rc_original+eps*1e7,zc_original,...
                          input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                          input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
[~,~,minus] = bulgesqueeze(rc_original-eps*1e7,zc_original,...
                           input.bulge_position,input.bulge_magnitude,input.bulge_radius,...
                           input.squeeze_position,input.squeeze_magnitude,input.squeeze_radius);
grid_out.dx = 0.5.*(abs(plus-original)+abs(minus-original))/(eps*1e7).*grid_vertical.dx;
% Now rotate the grid back to vertical:
[grid_out.rbl,grid_out.zbl] = rotate(grid_out.rbl,grid_out.zbl,-pi/2);
[grid_out.rbr,grid_out.zbr] = rotate(grid_out.rbr,grid_out.zbr,-pi/2);
[grid_out.rtl,grid_out.ztl] = rotate(grid_out.rtl,grid_out.ztl,-pi/2);
[grid_out.rtr,grid_out.ztr] = rotate(grid_out.rtr,grid_out.ztr,-pi/2);
[grid_out.rc,grid_out.zc] = rotate(grid_out.rc,grid_out.zc,-pi/2);