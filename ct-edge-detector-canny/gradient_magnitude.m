function [Imag, Idir] = gradient_magnitude(I, sigma) 

[Ix, Iy] = image_derivatives(I, sigma);

Imag = sqrt(Ix .* Ix + Iy .* Iy);

Idir = atan2(Iy, Ix);