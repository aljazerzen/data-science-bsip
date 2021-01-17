function R = canny(I, sigma, t_low, t_high)

% figure; subplot(2, 3, 1); imshow(I); title("original");

[Imag, Idir] = gradient_magnitude(I, sigma);

% subplot(2, 3, 2); imshow(Imag); title("magnitude");

% convert direction to angle
Iangle = mod(Idir + pi, pi);

% discretize angles
Iangle = mod(round(Iangle / pi * 4), 4);

% subplot(2, 3, 3); imshow((Imag == 0) * (-1) + (Imag ~= 0) .* Iangle, [-1, 3]); title("angle");

% local maximum
Ilmax = Imag .* (
  (Iangle == 0 & circshift(Imag, [0, 1]) < Imag & circshift(Imag, [0, -1]) < Imag) |
  (Iangle == 1 & circshift(Imag, [1, 1]) < Imag & circshift(Imag, [-1, -1]) < Imag) |
  (Iangle == 2 & circshift(Imag, [1, 0]) < Imag & circshift(Imag, [-1, 0]) < Imag) |
  (Iangle == 3 & circshift(Imag, [1, -1]) < Imag & circshift(Imag, [-1, 1]) < Imag)
);

% subplot(2, 3, 4); imshow(Ilmax, []); title("local maxium");

% hysteresis threshold
Iweak = Ilmax >= t_low;
Istrong = Ilmax >= t_high;

Icontour = bwlabel(Iweak);

Itresh = ismember(Icontour, unique(Icontour(Istrong)));

% subplot(2, 3, 5); imshow(Itresh, [0 1]); title("hysteresis threshold");

R = Itresh;
