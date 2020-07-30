function distance = minfunc(p_premap,dxSOL_target,dySOL_target,bulge_pos,bulge_mag,bulge_rad,squeeze_pos,squeeze_mag,squeeze_rad)
    
    [x_mapped,y_mapped] = bulgesqueeze(p_premap(1)*[-0.5,0.5],p_premap(2)*[1,1],...
                                       bulge_pos,bulge_mag,bulge_rad,...
                                       squeeze_pos,squeeze_mag,squeeze_rad);

    distance = abs(dySOL_target-y_mapped(1))+abs(dxSOL_target-abs(diff(x_mapped)));
    
end