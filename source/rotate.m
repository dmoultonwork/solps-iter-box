function [x_mapped,y_mapped] = rotate(x,y,angle)
    % Express grid points as complex numbers:
    z=x+1i*y;
    % Make the rotation:
    w=exp(1i*angle)*z;
    % Return the real and imaginary parts of w:
    x_mapped = real(w);
    y_mapped = imag(w);
end