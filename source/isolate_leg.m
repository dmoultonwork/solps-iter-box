function grid = isolate_leg(input)
% Function to take an existing sno grid file and isolate a requested divertor
% leg, add guard cells to the divertor entrance and put that leg in a new
% output grid file

%% Read the original grid:
fgrid_original=fopen(input.existing_gridfile,'r');
% Get grid dimensions:
for il = 1:3
    fgetl(fgrid_original);
end
tline = fgetl(fgrid_original);
RBtor = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
nx = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
ny = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
ncut = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
nxcut = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
nycut = str2num(tline(find(tline=='=')+1:end));
nycut = nycut(1);
tline = fgetl(fgrid_original);
niso = str2num(tline(find(tline=='=')+1:end));
tline = fgetl(fgrid_original);
nxiso = str2num(tline(find(tline=='=')+1:end));
while isempty(strfind(tline,'=='))
    tline = fgetl(fgrid_original);
end
rbl_orig = zeros(nx+2,ny+2); % rbl of original grid
rbr_orig = zeros(nx+2,ny+2); % rbr of original grid
rtl_orig = zeros(nx+2,ny+2); % rtl of original grid
rtr_orig = zeros(nx+2,ny+2); % rtr of original grid
rc_orig = zeros(nx+2,ny+2); %rc of original grid
zbl_orig = zeros(nx+2,ny+2); % zbl of original grid
zbr_orig = zeros(nx+2,ny+2); % zbr of original grid
ztl_orig = zeros(nx+2,ny+2); % ztl of original grid
ztr_orig = zeros(nx+2,ny+2); % ztr of original grid
zc_orig = zeros(nx+2,ny+2); % zc of original grid
fratio_original = zeros(nx+2,ny+2); % Field ratio of original grid
for iy=1:ny+2
    for ix=1:nx+2
        tline = fgetl(fgrid_original);
        ib1 = strfind(tline,'(');
        ib2 = strfind(tline,')');
        p1 = str2num(tline(ib1(2)+1:ib2(2)-1));
        p2 = str2num(tline(ib1(3)+1:ib2(3)-1));
        
        tline = fgetl(fgrid_original);
        ib1 = strfind(tline,'=');
        ib2 = strfind(tline,'(');
        ib3 = strfind(tline,')');
        fratio_original(ix,iy) = str2num(tline(ib1(1)+1:ib2(1)-1));
        pc = str2num(tline(ib2+1:ib3-1));
        
        tline = fgetl(fgrid_original);
        ib1 = strfind(tline,'(');
        ib2 = strfind(tline,')');
        p3 = str2num(tline(ib1(1)+1:ib2(1)-1));
        p4 = str2num(tline(ib1(2)+1:ib2(2)-1));
        
        fgetl(fgrid_original);
        
        rbl_orig(ix,iy) = p3(1);
        zbl_orig(ix,iy) = p3(2);
        rbr_orig(ix,iy) = p4(1);
        zbr_orig(ix,iy) = p4(2); 
        rtl_orig(ix,iy) = p1(1);
        ztl_orig(ix,iy) = p1(2);
        rtr_orig(ix,iy) = p2(1);
        ztr_orig(ix,iy) = p2(2);
        rc_orig(ix,iy) = pc(1);
        zc_orig(ix,iy) = pc(2);
    end
end
fclose(fgrid_original);

%% Isolate the leg:
nxcut = [-1,nxcut(1:2),nxiso,nxcut(3:4),nx+1];
xinds = nxcut(input.poloidal_section_number)+2:nxcut(input.poloidal_section_number+1)+1;
rbl_isolate = rbl_orig(xinds,:);
rbr_isolate= rbr_orig(xinds,:);
rtl_isolate = rtl_orig(xinds,:);
rtr_isolate = rtr_orig(xinds,:);
rc_isolate = rc_orig(xinds,:);
zbl_isolate = zbl_orig(xinds,:);
zbr_isolate= zbr_orig(xinds,:);
ztl_isolate = ztl_orig(xinds,:);
ztr_isolate = ztr_orig(xinds,:);
zc_isolate = zc_orig(xinds,:);
fratio_isolate = fratio_original(xinds,:);

%% Add guard cells to the required end of the leg
if ~input.targetendright % guard cells to be added to the right end
    ixg = size(rbl_isolate,1);
    Rv_divent = [rbr_isolate(ixg,1),rtr_isolate(ixg,:)];
    Rv_b4divent = [rbl_isolate(ixg,1),rtl_isolate(ixg,:)];
    Zv_divent = [zbr_isolate(ixg,1),ztr_isolate(ixg,:)];
    Zv_b4divent = [zbl_isolate(ixg,1),ztl_isolate(ixg,:)];
else
    ixg = 1;
    Rv_divent = [rbl_isolate(ixg,1),rtl_isolate(ixg,:)];
    Rv_b4divent = [rbr_isolate(ixg,1),rtr_isolate(ixg,:)];
    Zv_divent = [zbl_isolate(ixg,1),ztl_isolate(ixg,:)];
    Zv_b4divent = [zbr_isolate(ixg,1),ztr_isolate(ixg,:)];
end
spol_extrap = [zeros(ny+3,1),sqrt((Rv_divent-Rv_b4divent).^2+(Zv_divent-Zv_b4divent).^2)'];
R_extrap = zeros(1,ny+3);
Z_extrap = zeros(1,ny+3);
for iy=1:ny+3
    if (abs(Rv_divent-Rv_b4divent)<1E5*eps)
        R_extrap(iy) = Rv_divent(iy);
    else
        R_extrap(iy) = interp1(spol_extrap(iy,:),[Rv_b4divent(iy),Rv_divent(iy)],spol_extrap(iy,2)+input.dxg,'linear','extrap');
    end
    if (abs(Zv_divent-Zv_b4divent)<1E5*eps)
        Z_extrap(iy) = Zv_divent(iy);
    else
        Z_extrap(iy) = interp1(spol_extrap(iy,:),[Zv_b4divent(iy),Zv_divent(iy)],spol_extrap(iy,2)+input.dxg,'linear','extrap');
    end
end


if ~input.targetendright
    rbl_guard = rbr_isolate(end,:);
    rbr_guard = R_extrap(1:end-1);
    rtl_guard = rtr_isolate(end,:);
    rtr_guard = R_extrap(2:end);
    rc_guard = 0.25*(rbl_guard+rbr_guard+rtl_guard+rtr_guard);
    rbl_isolate = [rbl_isolate;rbl_guard];
    rbr_isolate = [rbr_isolate;rbr_guard];
    rtl_isolate = [rtl_isolate;rtl_guard];
    rtr_isolate = [rtr_isolate;rtr_guard];
    rc_isolate = [rc_isolate;rc_guard];
    zbl_guard = zbr_isolate(end,:);
    zbr_guard = Z_extrap(1:end-1);
    ztl_guard = ztr_isolate(end,:);
    ztr_guard = Z_extrap(2:end);
    zc_guard = 0.25*(zbl_guard+zbr_guard+ztl_guard+ztr_guard);
    zbl_isolate = [zbl_isolate;zbl_guard];
    zbr_isolate = [zbr_isolate;zbr_guard];
    ztl_isolate = [ztl_isolate;ztl_guard];
    ztr_isolate = [ztr_isolate;ztr_guard];
    zc_isolate = [zc_isolate;zc_guard];
    fratio_isolate = [fratio_isolate;mean(fratio_original([xinds(end),xinds(end)+1],:))]; % This interpolation is dubious!!
else
    rbl_guard = R_extrap(1:end-1);
    rbr_guard = rbl_isolate(1,:);
    rtl_guard = R_extrap(2:end);
    rtr_guard = rtl_isolate(1,:);
    rc_guard = 0.25*(rbl_guard+rbr_guard+rtl_guard+rtr_guard);
    rbl_isolate = [rbl_guard;rbl_isolate];
    rbr_isolate = [rbr_guard;rbr_isolate];
    rtl_isolate = [rtl_guard;rtl_isolate];
    rtr_isolate = [rtr_guard;rtr_isolate];
    rc_isolate = [rc_guard;rc_isolate];
    zbl_guard = Z_extrap(1:end-1);
    zbr_guard = zbl_isolate(1,:);
    ztl_guard = Z_extrap(2:end);
    ztr_guard = ztl_isolate(1,:);
    zc_guard = 0.25*(zbl_guard+zbr_guard+ztl_guard+ztr_guard);
    zbl_isolate = [zbl_guard;zbl_isolate];
    zbr_isolate = [zbr_guard;zbr_isolate];
    ztl_isolate = [ztl_guard;ztl_isolate];
    ztr_isolate = [ztr_guard;ztr_isolate];
    zc_isolate = [zc_guard;zc_isolate];
    fratio_isolate = [mean(fratio_original([xinds(1)-1,xinds(1)],:));fratio_isolate]; % This interpolation is dubious!!
end
  
%% Output:
grid = grid_class;
grid.file_location = [input.baserun_dir,'/grid.sno'];
grid.rbl = rbl_isolate;
grid.rbr = rbr_isolate;
grid.rtl = rtl_isolate;
grid.rtr = rtr_isolate;
grid.rc = rc_isolate;
grid.zbl = zbl_isolate;
grid.zbr = zbr_isolate;
grid.ztl = ztl_isolate;
grid.ztr = ztr_isolate;
grid.zc = zc_isolate;
grid.iysep = nycut+2;
grid.fratio = fratio_isolate;
grid.RBtor = RBtor;
grid.nx = size(grid.rbl,1)-2;
grid.ny = ny;
% y-y_sep at the inner or outer midplane (depending on whether an inner or outer leg is being isolated):
tmp = find(diff(zc_orig(:,grid.iysep)>0));
[~,iximp] = min(abs(zc_orig(tmp(1):tmp(1)+1,grid.iysep)));
iximp = iximp+tmp(1)-1;
[~,ixomp] = min(abs(zc_orig(tmp(2):tmp(2)+1,grid.iysep)));
ixomp = ixomp+tmp(2)-1;
if (ncut>2)
   if (input.poloidal_section_number<=3)
       disp('Calculating y-y_sep at inner midplane');
       ixmp = iximp;
   else
       disp('Calculating y-y_sep at outer midplane');
       ixmp = ixomp;
   end
else
    disp('Calculating y-y_sep at outer midplane');
    ixmp = ixomp;
end
dy_mp = sqrt((0.5*(rbr_orig(ixmp,grid.iysep:end)+rbl_orig(ixmp,grid.iysep:end))-0.5*(rtr_orig(ixmp,grid.iysep:end)+rtl_orig(ixmp,grid.iysep:end))).^2+...
             (0.5*(zbr_orig(ixmp,grid.iysep:end)+zbl_orig(ixmp,grid.iysep:end))-0.5*(ztr_orig(ixmp,grid.iysep:end)+ztl_orig(ixmp,grid.iysep:end))).^2);
grid.ymysep_mp = zeros(1,grid.ny+2);
grid.ymysep_mp(grid.iysep:end) = [0,cumsum(sqrt(diff(rc_orig(ixmp,grid.iysep:end)).^2+diff(zc_orig(ixmp,grid.iysep:end)).^2))]+dy_mp(1)/2;
% apll at divertor entrance. Don't trust the grid accuracy around the
% x-point so calculate the parallel area at the midplane and multiply by
% Btot_midplane/Btot_entrance:
Btor = RBtor./rc_orig;
Btot = Btor.*sqrt(1+fratio_original.^2./(1-fratio_original.^2));
Btot_mp = Btot(ixmp,:);
if ~input.targetendright
    Btot_entrance = mean(Btot([xinds(end),xinds(end)+1],:));
else
    Btot_entrance = mean(Btot([xinds(1)-1,xinds(1)],:));
end
apll_mp = 2*pi*rc_orig(ixmp,grid.iysep:end).*dy_mp.*abs(fratio_original(ixmp,grid.iysep:end));
grid.apll_entrance = zeros(1,grid.ny+2);
grid.apll_entrance(grid.iysep:end) = apll_mp.*Btot_mp(grid.iysep:end)./Btot_entrance(grid.iysep:end);