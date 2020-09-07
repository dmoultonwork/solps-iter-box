function grid = create_vertical_grid(input)

%% Main (non-guard) cells:
% Calculate the R coordinates of the radial faces of a straight-down box:
if input.ly>1e10
    rface = linspace(-input.dy*input.pfrfrac,+input.dy*(1-input.pfrfrac),input.ny+1);
else
    dyp = input.pfrfrac*input.dy;
    dys = (1-input.pfrfrac)*input.dy;
    np = input.ny*input.pfrfrac;
    ns = input.ny*(1-input.pfrfrac);
    rfacep = 1-exp(-linspace(0,1,np+1)/input.ly);
    rfacep = rfacep/rfacep(end)*dyp;
    rfacep = rfacep-dyp;
    rfaces = 1-exp(-linspace(0,1,ns+1)/input.ly);
    rfaces = rfaces/rfaces(end)*dys;
    rfaces = -fliplr(rfaces)+dys;
    rface = [rfacep,rfaces(2:end)];
end
rface = [rface(1)-(input.nyp:-1:1)*(rface(2)-rface(1)),rface]; % Add on additional PFR cells in y direction
% And the Z coordinates of the poloidal faces of a straight-down box:
if input.lx>1e10
    zface = linspace(input.dx/2,-input.dx/2,input.nx+1);
else
    zface = 1-exp(-linspace(0,1,input.nx+1)/input.lx);
    zface = zface/zface(end)*input.dx;
    zface = -zface+input.dx/2;
end
% Calculate the R and Z coordinates of the cell centres and vertices:
rc = repmat(0.5*(rface(1:end-1)+rface(2:end)),input.nx,1);
zc = repmat(0.5*(zface(1:end-1)+zface(2:end))',1,input.ny+input.nyp);
zbl = repmat(zface(1:end-1)',1,input.ny+input.nyp);
zbr = repmat(zface(2:end)',1,input.ny+input.nyp);
rbl = repmat(rface(1:end-1),input.nx,1);
rtl = repmat(rface(2:end),input.nx,1);
%% Guard cells:
% Add guard cells on 'left' and 'right' (in SOLPS-speak):
zc = [zc(1,:)+abs(zface(1)-zface(2))/2+input.dyg/2;zc;zc(end,:)-abs(zface(end)-zface(end-1))/2-input.dyg/2];
rc = [rc(1,:);rc;rc(1,:)];
zbl = [zbl(1,:)+input.dxg;zbl;zbl(end,:)-abs(zface(end)-zface(end-1))];
zbr = [zbr(1,:)+abs(zface(1)-zface(2));zbr;zbr(end,:)-input.dxg];
rbl = [rbl(1,:);rbl;rbl(end,:)];
rtl = [rtl(1,:);rtl;rtl(end,:)];
% Add guard cells on 'bottom' and 'top':
zc = [zc(:,1),zc,zc(:,1)];
rc = [rc(:,1)-abs(rface(1)-rface(2))/2-input.dyg/2,rc,rc(:,end)+abs(rface(end)-rface(end-1))/2+input.dyg/2];
zbl = [zbl(:,1),zbl,zbl(:,1)];
zbr = [zbr(:,1),zbr,zbr(:,1)];
ztl = zbl;
ztr = zbr;
rbl = [rbl(:,1)-input.dyg,rbl,rbl(:,end)+abs(rface(end)-rface(end-1))];
rbr = rbl;
rtl = [rtl(:,1)-abs(rface(1)-rface(2)),rtl,rtl(:,end)+input.dyg];
rtr = rtl;
%% Output:
grid = grid_class;
grid.rc = rc;
grid.rbl = rbl;
grid.rbr = rbr;
grid.rtl = rtl;
grid.rtr = rtr;
grid.zc = zc;
grid.zbl = zbl;
grid.zbr = zbr;
grid.ztl = ztl;
grid.ztr = ztr;
grid.PFX = ones(input.nx+2,input.ny+2);
grid.dy = grid.rtl-grid.rbl;
grid.dx = grid.ztl-grid.ztr;
grid.iysep = find(grid.rc(1,:)>0,1,'first');
grid.nx = size(grid.rbl,1)-2;
grid.ny = size(grid.rbl,2)-2;
grid.RBtor = input.RBtor;