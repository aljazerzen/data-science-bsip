function [g, x] = gauss(sigma)
% this returns one dimentional array

x = -round(3.0*sigma):round(3.0*sigma);
g = exp(- x.^2 ./ (2 * sigma ^ 2)) / (sqrt(2 * pi) * sigma);
g = g / sum(g) ; % normalisation