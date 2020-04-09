function output_grid(grid,input)

fid = fopen([input.baserun_dir,'/grid.sno'],'w');
fprintf(fid,'\n');
fprintf(fid,'   Element output:\n');
fprintf(fid,'\n');
fprintf(fid,'    R*Btor = %f\n',input.RBtor);
fprintf(fid,'    nx     = %6d\n',input.nx+input.kink_nx*input.makekink);
fprintf(fid,'    ny     = %6d\n',input.ny+input.nyp);
fprintf(fid,'    ncut   =      0\n');
fprintf(fid,'    nxcut  =      0\n');
fprintf(fid,'    nycut  =      0\n');
fprintf(fid,'    niso   =     -1\n');
fprintf(fid,'    nxiso  =     -1\n');
fprintf(fid,'\n');
fprintf(fid,'   ========================================================================================\n');
ie = 1;
for ix = 1:input.nx+input.kink_nx*input.makekink+2;
    for iy = 1:input.ny+input.nyp+2;
        fprintf(fid,'   Element%5d = (%3d,%3d): (%17.10E,%17.10E)      (%17.10E,%17.10E)\n',ie,ix-1,iy-1,grid.rtl(ix,iy),grid.ztl(ix,iy),grid.rtr(ix,iy),grid.ztr(ix,iy));
        fprintf(fid,'   Field ratio  = %17.10E             (%17.10E,%17.10E)\n',grid.Bp(ix,iy)/sqrt(grid.Bp(ix,iy)^2+grid.Bt(ix,iy)^2),grid.rc(ix,iy),grid.zc(ix,iy));
        fprintf(fid,'                             (%17.10E,%17.10E)      (%17.10E,%17.10E)\n',grid.rbl(ix,iy),grid.zbl(ix,iy),grid.rbr(ix,iy),grid.zbr(ix,iy));
        fprintf(fid,'   ----------------------------------------------------------------------------------------\n');
        ie = ie+1;
    end
end

end