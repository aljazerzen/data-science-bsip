function [g, x] = gaussdx(sigma)
x = -round(3.0*sigma):round(3.0*sigma);
g = x .* exp(- x.^2 ./ (2 * sigma ^ 2)) / (sqrt(2 * pi) * sigma^3);
g = g / sum(abs(g)) ; % normalisation