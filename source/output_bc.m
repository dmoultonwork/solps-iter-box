function [conpar,qpll_x_mp] = output_bc(grid,input)
%function [fnxpll_x_mp,qpll_x_mp] = output_bc(grid,input)
iysep = grid.iysep;
conpar = zeros(1,grid.ny);
switch input.densbc
    case 'density'
        %% Fixed density boundary condition (exponential fall off along y-y_sep):
        conpar(iysep-1:end) = exp(-(grid.ymysep_mp(iysep:end-1)- grid.ymysep_mp(iysep))/input.lbccon);
        conpar = input.n0*conpar/max(conpar);
    case 'flux'
        %% Fixed density flux boundary condition: Ryoko 23022021
        fnxpll_x_mp = exp(-(grid.ymysep_mp(iysep:end-1)- grid.ymysep_mp(iysep))/input.lbcconfl).*(abs(grid.ymysep_mp(iysep:end-1)- grid.ymysep_mp(iysep))./grid.ymysep_mp(iysep)+input.nu0param);
        fnxpll_x_mp = input.nupll0*fnxpll_x_mp/max(fnxpll_x_mp);
        conpar(iysep-1:end) = fnxpll_x_mp.*grid.apll_entrance(iysep:end-1);
end
%% Fixed internal energy flux boundary condition (corresponds to exponential fall off in q|| along y-y_sep):
enpar = zeros(1,grid.ny);
qpll_x_mp = exp(-(grid.ymysep_mp(iysep:end-1)- grid.ymysep_mp(iysep))/input.lbcen); % qpll at the x-point, mapped to the midplane
qpll_x_mp = input.qpll0*qpll_x_mp/max(qpll_x_mp);
enpar(iysep-1:end) = qpll_x_mp.*grid.apll_entrance(iysep:end-1); % multiply by the parallel area at the divertor entrance to get the BC
disp(['input power integrates to ',num2str(2*sum(enpar)/1E6,'%.8f'),' MW (electrons plus ions)']);
%% Fixed internal energy flux boundary condition for the ion (22/10/2020, Ryoko) 
enipar = zeros(1,grid.ny);
qipll_x_mp = exp(-(grid.ymysep_mp(iysep:end-1)- grid.ymysep_mp(iysep))/input.lbcen); % qpll at the x-point, mapped to the midplane
qipll_x_mp = input.qipll0*qipll_x_mp/max(qipll_x_mp);
enipar(iysep-1:end) = qipll_x_mp.*grid.apll_entrance(iysep:end-1); % multiply by the parallel area at the divertor entrance to get the BC
%% Output the bcs to b2.boundary.parameters.out:
fid = fopen([input.ref_dir,'/b2.boundary.parameters'],'w');
fprintf(fid,' &BOUNDARY\n');
fprintf(fid,' NBC=%d\n',grid.ny+3);
if input.targetendright
    fprintf(fid,[' BCCHAR    =         ''S'',         ''N'', ',repmat('        ''W'', ',1,grid.ny),'        ''E'',\n']);
    fprintf(fid,' BCPOS     =%s\n',sprintf('%12d,',[-1,grid.ny,repmat(-1,1,grid.ny),grid.nx]));
else
    fprintf(fid,[' BCCHAR    =         ''S'',         ''N'', ',repmat('        ''E'', ',1,grid.ny),'        ''W'',\n']);
    fprintf(fid,' BCPOS     =%s\n',sprintf('%12d,',[-1,grid.ny,repmat(grid.nx,1,grid.ny),-1]));
end
fprintf(fid,' BCSTART   =%s\n',sprintf('%12d,',[0,0,0:grid.ny-1,0]));
fprintf(fid,' BCEND     =%s\n',sprintf('%12d,',[grid.nx-1,grid.nx-1,0:grid.ny-1,grid.ny-1]));
fprintf(fid,' BCENE     =%s\n',sprintf('%12d,',[5,5,repmat(8,1,grid.ny),12]));
fprintf(fid,' BCENI     =%s\n',sprintf('%12d,',[5,5,repmat(8,1,grid.ny),12]));
fprintf(fid,' BCPOT     =%s\n',sprintf('%12d,',[repmat(0,1,grid.ny+2),3]));
fprintf(fid,' ENEPAR    =%s\n',sprintf('%12e,',[0,0,enpar,4.0]));
fprintf(fid,' ENIPAR    =%s\n',sprintf('%12e,',[0,0,enipar,1.5]));%enpar-->enipar, 22/10/2020, Ryoko
fprintf(fid,' POTPAR    =%s\n',sprintf('%12e,',repmat(0,1,grid.ny+3)));
fprintf(fid,' BCCON(0,1)=%s CONPAR(0,1,1)=%s\n',sprintf('%2d,',[1 5]),sprintf('%12e,',[0 0]));
fprintf(fid,' BCCON(0,2)=%s CONPAR(0,2,1)=%s\n',sprintf('%2d,',[1 5]),sprintf('%12e,',[0 0]));
for it = 1:iysep-2
    fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 2]),it+2,sprintf('%12e,',[0 0]));
end
switch input.densbc
    case 'density'
        for it = iysep-1:grid.ny
            fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 1]),it+2,sprintf('%12e,',[0 conpar(it)]));
        end
    case 'flux'
        for it = iysep-1:grid.ny
            fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 8]),it+2,sprintf('%12e,',[0 conpar(it)])); %particle flux (Ryoko 23022021)
        end
end
fprintf(fid,' BCCON(0,%d)=%s CONPAR(0,%d,1)=%s\n',grid.ny+3,sprintf('%2d,',[1 3]),grid.ny+3,sprintf('%12e,',[0 0]));
fprintf(fid,' BCMOM(0,1)=%s MOMPAR(0,1,1)=%s\n',sprintf('%2d,',[5 5]),sprintf('%12e,',[0 0]));
fprintf(fid,' BCMOM(0,2)=%s MOMPAR(0,2,1)=%s\n',sprintf('%2d,',[5 5]),sprintf('%12e,',[0 0]));
for it = 1:iysep-2
%     fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 1]),it+2,sprintf('%12e,',[0 0]));
    fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 2]),it+2,sprintf('%12e,',[0 0]));%velocity gradient
end
for it = iysep-1:grid.ny
    fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s\n',it+2,sprintf('%2d,',[1 2]),it+2,sprintf('%12e,',[0 0]));
end
fprintf(fid,' BCMOM(0,%d)=%s MOMPAR(0,%d,1)=%s MOMPAR(0,%d,2)=%s\n',grid.ny+3,sprintf('%2d,',[1 3]),grid.ny+3,sprintf('%12e,',[0 1]),grid.ny+3,sprintf('%12e,',[1 1]));
fprintf(fid,' GAMMAI=1.666666667, GAMMAE=0.0,\n');
fprintf(fid,' LBNDUSR=F,\n');
fprintf(fid,' /');
fclose(fid);
