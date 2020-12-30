function y = haar_like_filter(x, B1, B2)
  len = length(x);

  c = 2 * (B2 - B1) / (2 * B1 + 1);

  % add zero padding to x
  % pad_left = B2 + 1;
  % pad_right = B2;
  % x = [zeros(pad_left, 1); x; zeros(pad_right, 1)];

  % init y1 and y2 (with 1 left zero padding)
  % y1 = zeros(1 + len, 1);
  % y2 = zeros(1 + len, 1);

  % loop over signal, computing LCCD
  % for n = 1:len
    % n_y = n + 1;
    % n_x = n + pad_left;
    
    % y1(n_y) = y1(n_y-1) + x(n_x+B1) - x(n_x-B1-1);
    % y2(n_y) = y2(n_y-1) + x(n_x+B2) - x(n_x-B2-1);
  % end

  % remove y padding
  % y1 = y1(2:end);
  % y2 = y2(2:end);

  a1 = [1; -1];
  b1 = [1; zeros(2 * B1 - 1, 1); -1];
  u1 = filter(b1, a1, x);

  a2 = [1; -1];
  b2 = [1; zeros(2 * B2 - 1, 1); -1];
  u2 = filter(b2, a2, x);
  
  y1 = [u1(B1+1:end); zeros(B1, 1)];
  y2 = [u2(B2+1:end); zeros(B2, 1)];

  y = -y2 + (c+1)*y1;
end