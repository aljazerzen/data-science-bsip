
Idir = -pi:0.01:pi;

% convert direction to angle
Iangle = mod(Idir + pi, pi);

% discretize angles
Iangle = mod(round(Iangle / pi * 4), 4)


I = -ones(110, 110);
for i = 1:size(Idir, 2)
  x = round(50 * cos(Idir(i))) + 55;
  y = round(50 * sin(-Idir(i))) + 55;
  I(y, x) = Iangle(i);
end

imshow(((I + 1) * 32), [])