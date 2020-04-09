function make_plots(grid_final,grid_norot,contour,conpar,enpar,input)

rcentre = grid_norot.rc(1,2:end-1);
iysep = find(rcentre>=input.R0,1,'first');

% Plot the B2.5 grid:
figure('windowstyle','docked');
subplot(3,2,[1,3,5]); hold on;
axis equal;
plot(reshape(grid_final.rc,1,[]),reshape(grid_final.zc,1,[]),'.k');
patch([reshape(grid_final.rbl,1,[]);reshape(grid_final.rbr,1,[]);reshape(grid_final.rtr,1,[]);reshape(grid_final.rtl,1,[])],...
      [reshape(grid_final.zbl,1,[]);reshape(grid_final.zbr,1,[]);reshape(grid_final.ztr,1,[]);reshape(grid_final.ztl,1,[])],'w','facecolor','none','edgecolor','k');
plot(grid_final.rc(:,iysep+1),grid_final.zc(:,iysep+1),'or'); % First SOL tube  
% Plot the wall segments:
for is=1:size(contour.seg,1)
    plot([contour.seg(is,1),contour.seg(is,3)],[contour.seg(is,2),contour.seg(is,4)],'-g','marker','.');
end
for is=1:size(contour.pump,1)
    plot([contour.pump(is,1),contour.pump(is,3)],[contour.pump(is,2),contour.pump(is,4)],'-r','marker','.');
end
for ic=1:length(contour.tria)
    plot(contour.tria{ic}(:,1),contour.tria{ic}(:,2),'-c','marker','.');
end
%% Plot the main ion density and internal energy flux density BCs:
subplot(3,2,2); hold on;
plot(rcentre-input.R0,conpar,'marker','.'); xlabel('y-y_{sep} (m)'); ylabel('conpar for bccon 1');
subplot(3,2,4); hold on;
plot(rcentre-input.R0,enpar,'marker','.'); xlabel('y-y_{sep} (m)'); ylabel('enpar for bcen 5');
title(['integrates to ',num2str(sum(enpar.*(2*pi*rcentre.*diff(grid_norot.rtl(1,1:end-1)))/1E6)),' MW']);
subplot(3,2,6); hold on;
pitch = grid_final.Bp(2:end-1,iysep+1)./sqrt(grid_final.Bp(2:end-1,iysep+1).^2+grid_final.Bt(2:end-1,iysep+1).^2);
dspol = [0;cumsum(sqrt(diff(grid_final.rc(2:end-1,iysep+1)).^2+diff(grid_final.zc(2:end-1,iysep+1)).^2))];
Btot = sqrt(grid_final.Bp(2:end-1,iysep+1).^2+grid_final.Bt(2:end-1,iysep+1).^2);
plot(1./grid_final.rc(2:end-1,iysep+1),Btot);
xlabel('parallel distance along separatrix (m)'); ylabel('magnetic field strength (T)');
