function contour = create_eirene_arrays(grid,input)

contour = contour_class;

switch input.wall_scenario
    case 'tight'
        pumplength = input.pumplength/input.dx;
        Rtop = flipud(0.99*grid.rbl(2:end,end)+0.01*grid.rbl(1:end-1,end-1));
        Ztop = flipud(0.99*grid.zbl(2:end,end)+0.01*grid.zbl(1:end-1,end-1));
        poldist = [0;cumsum(sqrt(diff(Rtop).^2+diff(Ztop).^2))];
        contour.pump = [Rtop(1),Ztop(1),interp1(poldist,Rtop,pumplength),interp1(poldist,Ztop,pumplength)];
    case 'cyd'
        % Convert pump-related input dimensions to metres:
        pumpthroat = input.pumpthroat*(grid.rtl(end,1)-grid.rtr(1,1));
        pumpprotect = input.pumpprotect*(grid.rtl(end,1)-grid.rtr(1,1));
        % First zone:
        contour.tria{1} = [[grid.rbr(1:end-1,end),grid.zbr(1:end-1,end)];... % Start from the top left of the grid and go along the top edge to the top right of the grid
                           [grid.rbl(end,end),grid.zbr(1,end)];... % Go vertically up to a point level with the top left of the grid
                           [grid.rbr(1,end),grid.zbr(1,end)]]; % Close the contour
        contour.seg = [grid.rbr(1,end),grid.zbr(1,end),grid.rbl(end,end),grid.zbr(1,end);...
                       grid.rbl(end,end),grid.zbr(1,end),grid.rbl(end,end),grid.zbl(end,end)];
        % Second zone:
        contour.tria{2} = [grid.rtr(1,1),grid.ztr(1,1)]; % Start from the bottom left of the grid
        contour.tria{2} = [contour.tria{2};...
                           [grid.rtr(1,1),grid.ztr(end-1,1)];... % Otherwise just go vertically down to a point level with the bottom right of the grid
                           flipud([grid.rtr(1:end-1,1),grid.ztr(1:end-1,1)])]; % Close the contour
        contour.seg = [contour.seg;...
                       grid.rtl(end,1),grid.ztl(end,1),grid.rtr(1,1),grid.ztl(end,1);...
                       grid.rtr(1,1),grid.ztl(end,1),grid.rtr(1,1),grid.ztr(1,1)];
        % Segment to protect the pump from CX atoms:
        protectseg = [grid.rtr(1,1)+pumpthroat+pumpprotect,grid.ztr(end-1,1)+pumpthroat,grid.rtr(1,1)+pumpthroat,grid.ztr(end-1,1)+pumpthroat+pumpprotect];
        contour.seg = [contour.seg;protectseg];
        contour.pump = [protectseg(1)-0.01*(grid.rtl(end,1)-grid.rtr(1,1)),protectseg(2),protectseg(3),protectseg(4)-0.01*(grid.rtl(end,1)-grid.rtr(1,1))];
    case 'existing'
        % Read in the existing wall file (assumed to be in units of mm)
        wall_orig = dlmread(input.existing_wallfile)/1000;
        
        % Pick out the portion of the wall that we want to coincide with
        % the top contour:
        [~,itl] = min(sqrt((wall_orig(:,1)-input.wall_tl(1)).^2+(wall_orig(:,2)-input.wall_tl(2)).^2));
        [~,itr] = min(sqrt((wall_orig(:,1)-input.wall_tr(1)).^2+(wall_orig(:,2)-input.wall_tr(2)).^2));
        % Make sure that the top wall goes from top right to top left:
        if itr<itl
            wall_top = wall_orig(itr:itl,:);
        else
            wall_top = flipud(wall_orig(itl:itr,:));
        end
        % First contour contains the top edge of the B2.5 grid and the top wall:
        contour.tria{1} = [[grid.rbr(1:end-1,end),grid.zbr(1:end-1,end)];... % Start from the top left of the B2.5 grid and go along the top edge to the top right of the grid
                           wall_top;... % Go along the required length of the existing wall file
                           [grid.rbr(1,end),grid.zbr(1,end)]]; % Close the contour at the top left of the B2.5 grid
        contour.limpos_tr = 1;
        contour.seg = [grid.rbr(end-1,end),grid.zbr(end-1,end),wall_top(1,:)];
        for i=1:size(wall_top,1)-1
            contour.seg = [contour.seg;[wall_top(i,:),wall_top(i+1,:)]];
        end
        contour.seg = [contour.seg;[wall_top(end,:),grid.rbr(1,end),grid.zbr(1,end)]];
        contour.limpos_tl = size(contour.seg,1);
        
        % Pick out the portion of the wall that we want to coincide with
        % the bottom contour:
        [~,ibl] = min(sqrt((wall_orig(:,1)-input.wall_bl(1)).^2+(wall_orig(:,2)-input.wall_bl(2)).^2));
        [~,ibr] = min(sqrt((wall_orig(:,1)-input.wall_br(1)).^2+(wall_orig(:,2)-input.wall_br(2)).^2));
        % Make sure that the bottom wall goes from bottom left to bottom right:
        if ibl<ibr
            wall_bottom = wall_orig(ibl:ibr,:);
        else
            wall_bottom = flipud(wall_orig(ibr:ibl,:));
        end
        % Second contour contains the bottom edge of the B2.5 grid and the bottom wall:
        contour.tria{2} = [[grid.rtr(1,1),grid.ztr(1,1)];... % Start from the bottom left of the B2.5 grid
                           wall_bottom;... % Go along the required length of the existing wall file
                           flipud([grid.rtr(1:end-1,1),grid.ztr(1:end-1,1)])]; % Come back from the bottom right along the bottom edge of the B2.5 grid and close the contour
        contour.limpos_bl = size(contour.seg,1)+1;
        contour.seg = [contour.seg;[grid.rtr(1,1),grid.ztr(1,1),wall_bottom(1,:)]];
        for i=1:size(wall_bottom,1)-1
            contour.seg = [contour.seg;[wall_bottom(i,:),wall_bottom(i+1,:)]];
        end
        contour.seg = [contour.seg;[wall_bottom(end,:),grid.rtr(end-1,1),grid.ztr(end-1,1)]];
        contour.limpos_br = size(contour.seg,1);
        
        % Pump contour directly from user input:
        contour.pump = input.pump;
    otherwise
        error('wall scenario ''%s'' not recognised',input.wall_scenario);
end
              
end