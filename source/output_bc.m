function [conpar,enpar] = output_bc(grid_norot,input)
% Fixed density boundary condition: 
rcentre = grid_norot.rc(1,2:end-1);
iysep = find(rcentre>=input.R0,1,'first');
conpar = zeros(1,input.ny+input.nyp);
conpar(iysep:end) = exp(-(rcentre(iysep:end)- rcentre(iysep))/input.lbccon);
conpar = input.n0*conpar/max(conpar);
%% Fixed internal energy flux density boundary condition:
enpar = zeros(1,input.ny+input.nyp);
enpar(iysep:end) = exp(-(rcentre(iysep:end)- rcentre(iysep))/input.lbcen);
enpar = input.powerin*enpar/sum(enpar.*(2*pi*rcentre.*diff(grid_norot.rbl(1,2:end))));
enpar(enpar<1e4 & rcentre<input.R0) = 0;
%% Output the bcs to b2.boundary.parameters.out:
fid = fopen([input.ref_dir,'/b2.boundary.parameters'],'w');
fprintf(fid,' &BOUNDARY\n');
fprintf(fid,' NBC=%d\n',input.ny+input.nyp+3);
fprintf(fid,[' BCCHAR    =         ''S'',         ''N'', ',repmat('        ''W'', ',1,input.ny+input.nyp),'        ''E'',\n']);
fprintf(fid,' BCPOS     =%s\n',sprintf('%12d,',[-1,input.ny+input.nyp,repmat(-1,1,input.ny+input.nyp),input.nx+input.makekink*input.kink_nx]));
fprintf(fid,' BCSTART   =%s\n',sprintf('%12d,',[0,0,0:input.ny+input.nyp-1,0]));
fprintf(fid,' BCEND     =%s\n',sprintf('%12d,',[input.nx+input.makekink*input.kink_nx-1,input.nx+input.makekink*input.kink_nx-1,0:input.ny+input.nyp-1,input.ny+input.nyp-1]));
fprintf(fid,' BCENE     =%s\n',sprintf('%12d,',[5,5,repmat(5,1,input.ny+input.nyp),12]));
fprintf(fid,' BCENI     =%s\n',sprintf('%12d,',[5,5,repmat(5,1,input.ny+input.nyp),12]));
fprintf(fid,' BCPOT     =%s\n',sprintf('%12d,',[repmat(0,1,input.ny+input.nyp+2),3]));
fprintf(fid,' ENEPAR    =%s\n',sprintf('%12e,',[0,0,enpar,4.0]));
fprintf(fid,' ENIPAR    =%s\n',sprintf('%12e,',[0,0,enpar,1.5]));
fprintf(fid,' POTPAR    =%s\n',sprintf('%12e,',repmat(0,1,input.ny+input.nyp+3)));
fprintf(fid,' BCCON(0,1)=%s CONPAR(0,1,1)=%s\n',sprintf('%2d,',[1 5]),sprintf('%12e,',[0 0]));
fprintf(fid,' BCCON(0,2)=%s CONPAR(0,2,1)=%s\n',sprintf('%2d,',[1 5]),sprintf('%12e,',[0 0]));
for it = 1:iysep-1
    fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 2]),it+2,sprintf('%12e,',[0 0]));
end
for it = iysep:input.ny+input.nyp
    fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 1]),it+2,sprintf('%12e,',[0 conpar(it)]));
end
fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',input.ny+input.nyp+3,sprintf('%2d,',[1 3]),input.ny+input.nyp+3,sprintf('%12e,',[0 0]));
fprintf(fid,' BCMOM(0,1)=%s MOMPAR(0,1,1)=%s\n',sprintf('%2d,',[5 5]),sprintf('%12e,',[0 0]));
fprintf(fid,' BCMOM(0,2)=%s MOMPAR(0,2,1)=%s\n',sprintf('%2d,',[5 5]),sprintf('%12e,',[0 0]));
for it = 1:iysep-1
    fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 1]),it+2,sprintf('%12e,',[0 0]));
end
for it = iysep:input.ny+input.nyp
    fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 2]),it+2,sprintf('%12e,',[0 0]));
end
fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s MOMPAR(0,%d,2)=%s\n',input.ny+input.nyp+3,sprintf('%2d,',[1 3]),input.ny+input.nyp+3,sprintf('%12e,',[0 1]),input.ny+input.nyp+3,sprintf('%12e,',[1 1]));
fprintf(fid,' GAMMAI=1.666666667, GAMMAE=0.0,\n');
fprintf(fid,' LBNDUSR=F,\n');
fprintf(fid,' /');
fclose(fid);