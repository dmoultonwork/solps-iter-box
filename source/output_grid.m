function output_grid(grid)

fid = fopen(grid.file_location,'w');
fprintf(fid,'\n');
fprintf(fid,'   Element output:\n');
fprintf(fid,'\n');
fprintf(fid,'    R*Btor =%19.14f\n',grid.RBtor);
fprintf(fid,'    nx     =%12d\n',grid.nx);
fprintf(fid,'    ny     =%12d\n',grid.ny);
fprintf(fid,'    ncut   =%12d\n',0);
fprintf(fid,'    nxcut  =%12d\n',0);
fprintf(fid,'    nycut  =%12d\n',0);
fprintf(fid,'    niso   =%12d\n',-1);
fprintf(fid,'    nxiso  =%12d\n',-1);
fprintf(fid,'\n');
fprintf(fid,'   ========================================================================================\n');
ie = 0;
for iy = 1:grid.ny+2;
    for ix = 1:grid.nx+2;
        fprintf(fid,'   Element%7d = (%3d,%3d): (%17.10E,%17.10E)      (%17.10E,%17.10E)\n',ie,ix-1,iy-1,grid.rtl(ix,iy),grid.ztl(ix,iy),grid.rtr(ix,iy),grid.ztr(ix,iy));
        fprintf(fid,'   Field ratio  = %17.10E             (%17.10E,%17.10E)\n',grid.fratio(ix,iy),grid.rc(ix,iy),grid.zc(ix,iy));
        fprintf(fid,'                               (%17.10E,%17.10E)      (%17.10E,%17.10E)\n',grid.rbl(ix,iy),grid.zbl(ix,iy),grid.rbr(ix,iy),grid.zbr(ix,iy));
        fprintf(fid,'   ----------------------------------------------------------------------------------------\n');
        ie = ie+1;
    end
end

end