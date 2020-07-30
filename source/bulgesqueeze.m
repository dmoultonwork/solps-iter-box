% Assume a horizontal grid as input
function [x_mapped,y_mapped,z] = bulgesqueeze(x,y,bulge_pos,bulge_mag,bulge_rad,squeeze_pos,squeeze_mag,squeeze_rad)
    % Express grid points as complex numbers:
    z=x+1i*y;
    % Apply Ben's bulge mapping as many times as required:
    for ib=1:length(bulge_pos)
        z=z+bulge_mag(ib)*bulge_rad(ib)*(1./(z+1i*bulge_rad(ib)-bulge_pos(ib))+1./(z-1i*bulge_rad(ib)-bulge_pos(ib)));
    end
    % Rotate by pi/2:
    z=exp(1i*pi/2)*z;
    % Apply Ben's squeeze mapping as many times as required:
    for is=1:length(squeeze_pos)
        z=z+squeeze_mag(is)*squeeze_rad(is)*(1./(z+squeeze_rad(is)-squeeze_pos(is))+1./(z-squeeze_rad(is)-squeeze_pos(is)));
    end
    % Rotate back:
    z=exp(-1i*pi/2)*z;
    % Return the real and imaginary parts of w:
    x_mapped = real(z);
    y_mapped = imag(z);
end