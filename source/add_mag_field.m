function grid = add_mag_field(grid,input)
    grid.Bt = input.RBtor./grid.rc; % toroidal field
    grid.Bp = input.RBtor*input.FR0./grid.rc./grid.PFX; % poloidal field
    grid.fratio = grid.Bp./sqrt(grid.Bp.^2+grid.Bt.^2); % B_poloidal/B_total
    % y-y_sep at divertor entrance:
    ymysep_entrance = [0,cumsum(sqrt(diff(grid.rc(1,:)).^2+diff(grid.zc(1,:)).^2))]-sum(grid.dy(1,1:grid.iysep-1));
    % y-y_sep at midplane:
    grid.ymysep_mp = ymysep_entrance/input.PFX_mp;
    % Parallel area at the divertor entrance:
    grid.apll_entrance = 2*pi*grid.rc(1,:).*grid.dy(1,:).*grid.fratio(1,:);
end