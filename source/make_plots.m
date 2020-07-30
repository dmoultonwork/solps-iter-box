function make_plots(grid_final,rcentre,contour,conpar,enpar)

% Plot the B2.5 grid:
figure('windowstyle','docked');
subplot(3,2,[1,3,5]); hold on;
axis equal;
plot(reshape(grid_final.rc,1,[]),reshape(grid_final.zc,1,[]),'.k');
patch([reshape(grid_final.rbl,1,[]);reshape(grid_final.rbr,1,[]);reshape(grid_final.rtr,1,[]);reshape(grid_final.rtl,1,[])],...
      [reshape(grid_final.zbl,1,[]);reshape(grid_final.zbr,1,[]);reshape(grid_final.ztr,1,[]);reshape(grid_final.ztl,1,[])],'w','facecolor','none','edgecolor','k');
plot(grid_final.rc(:,grid_final.iysep),grid_final.zc(:,grid_final.iysep),'or'); % First SOL tube  
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
plot(rcentre(2:end-1),conpar,'marker','.'); xlabel('y-y_{sep} (m)'); ylabel('conpar for bccon 1');
subplot(3,2,4); hold on;
plot(rcentre(2:end-1),enpar,'marker','.'); xlabel('y-y_{sep} (m)'); ylabel('enpar for bcen 5');
subplot(3,2,6); hold on;
% Total B field at cell centres:
Btot = sqrt(grid_final.Bp.^2+grid_final.Bt.^2);
% Bp/Btotal at cell centres:
pitch = grid_final.Bp./Btot;
% Parallel distance at cell faces:
spll_rightface = [zeros(1,size(pitch,2));cumsum(grid_final.dx(2:end,:)./pitch(2:end,:))];
% Approximate mapping of Btot to cell faces:
Btot_rightface = [(Btot(1:end-1,:).*grid_final.dx(2:end,:)+Btot(2:end,:).*grid_final.dx(1:end-1,:))./(grid_final.dx(2:end,:)+grid_final.dx(1:end-1,:));zeros(1,size(pitch,2))];
% Plot the total B field as a function of parallel distance:
iyplot = grid_final.iysep;
plot(spll_rightface(1:end-1,iyplot),Btot_rightface(1:end-1,iyplot));
% plot(grid_final.Bp(2:end-1,2:end-1).*grid_final.dy(2:end-1,2:end-1).*grid_final.rc(2:end-1,2:end-1)); % To check for constant poloidal flux
xlabel('parallel distance along separatrix (m)'); ylabel('magnetic field strength (T)');
