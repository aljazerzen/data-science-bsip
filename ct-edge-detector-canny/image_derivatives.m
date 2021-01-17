function [Ix, Iy] = image_derivatives(I, sigma)
% applies blurring and gauss derivative in each direction

function R = c(A, B)
  R = conv2(padarray(A,floor(size(B) / 2),'replicate','both'), B, 'valid');
end

G = gauss(sigma);
D = gaussdx(sigma);

Ix = c(c(I, G'), D);
Iy = c(c(I, G), D');

end