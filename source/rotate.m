function [r_rot,z_rot] = rotate(r,z,origin,angle)
    [th,rho] = cart2pol(r-origin(1),z-origin(2));
    th = th+angle/360*2*pi;
    [r_rot,z_rot] = pol2cart(th,rho);
    r_rot = r_rot+origin(1);
    z_rot = z_rot+origin(2);
end