function R = canny(I, sigma, t_low, t_high)

pkg load image;

% figure; subplot(2, 3, 1); imshow(I); title("original");

[Imag, Idir] = gradient_magnitude(I, sigma);

% subplot(2, 3, 2); imshow(Imag); title("magnitude");
% subplot(2, 3, 3); imshow(Idir); title("direction");

% convert direction to angle
Iangle = mod(Idir + pi, pi);

% discretize angles
Iangle = mod(round(Iangle / pi * 4), 4);

% subplot(2, 3, 3); imshow((Imag == 0) * (-1) + (Imag ~= 0) .* Iangle, [-1, 3]); title("angle");

% local maximum
Ilmax = (
  (Iangle == 0 & circshift(Imag, [0, 1]) < Imag & circshift(Imag, [0, -1]) < Imag) |
  (Iangle == 1 & circshift(Imag, [1, 1]) < Imag & circshift(Imag, [-1, -1]) < Imag) |
  (Iangle == 2 & circshift(Imag, [1, 0]) < Imag & circshift(Imag, [-1, 0]) < Imag) |
  (Iangle == 3 & circshift(Imag, [1, -1]) < Imag & circshift(Imag, [-1, 1]) < Imag)
);

Ilmax = imerode(imdilate(Ilmax, strel('disk', 2, 0)), strel('disk', 2, 0));
Ilmax = Imag .* Ilmax;

% subplot(2, 3, 4); imshow(Ilmax, []); title("local maxium");

% hysteresis threshold
Iweak = Ilmax >= t_low;
Istrong = Ilmax >= t_high;

Icontour = bwlabel(Iweak);

Itresh = ismember(Icontour, unique(Icontour(Istrong)));

% subplot(2, 3, 5); imshow(Itresh, [0 1]); title("hysteresis threshold"); pause

R = Itresh;
