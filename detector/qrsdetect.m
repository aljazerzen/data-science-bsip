function QRSDetect(filename)

sig1 = val(1, :);
sig2 = val(2, :);

function y = haarLikeFilter(x, B1, B2)
  if (!(B1 < B2))
    printf("B1 must be less than B2\n")
    exit(1)
  endif
  if (!(0 < B1))
    printf("B2 must be greater than 0\n")
    exit(1)
  endif
  len = length(x);

  c = 2 * (B2 - B1) / (2 * B1 + 1)

  # add zero padding to x
  pad_left = B2 + 1;
  pad_right = B2;
  x = [zeros(pad_left, 1); x; zeros(pad_right, 1)];

  # init y1 and y2 (with 1 left zero padding)
  y1 = zeros(1 + len, 1);
  y2 = zeros(1 + len, 1);
  
  # loop over signal, computing LCCD
  for n = 1:len
    n_y = n + 1;
    n_x = n + pad_left;
    
    y1(n_y) = y1(n_y-1) + x(n_x+B1) - x(n_x-B1-1);
    y2(n_y) = y2(n_y-1) + x(n_x+B2) - x(n_x-B2-1);
  end

  # remove y padding
  y1 = y1(2:end);
  y2 = y2(2:end);
  y = -y2 + (c+1)*y1;
end

function s = get_score(x, y)
  x_left = [x(1:end-1); 0];
  x_right = [0; x(2:end)];
  x_2 = 2 * x - x_left - x_right;

  c1 = 0.55

  s = y .* (x + c1 * x_2);
end

function candiates = local_score_threshold(score, fs)
  local_max = movmax(abs(score), round(0.2 * fs));
  qualifies = abs(score) == local_max;
  candiates = find(qualifies);
end

function filtered = adaptive_score_threshold(score, candiates)
  S5 = sort(abs(score))(end-5);
  T = 0.1;
  W1 = T * S5

  betta1 = 1;
  betta2 = 1;

  m1 = -100;
  diffs = [0,0,0,0];

  tau = [5,4,3,2,1];
  tau = tau / sum(tau);

  filtered = [];
  for n = candiates'
    d = n - m1;
    Ie = sum(tau .* [d, diffs]);
    
    W2 = betta1 + betta2 * abs(d / Ie - round(d / Ie));

    t = W1 * W2;

    qualifies = abs(score(n)) > t;

    if qualifies
      filtered = [filtered; n];

      m1 = n;
      diffs = [d, diffs(1:3)];
    end
  end
end

function filtered = variation_ratio_test(x, candiates, fs)
  span = round(0.1 * fs);
  
  filtered = [];
  for n = candiates'
    from = max(n - span, 1);
    to = min(n + span, length(x));
    
    neighbourhood = x(from:to);

    u1 = max(neighbourhood) - min(neighbourhood);
    u2 = sum(abs(neighbourhood(2:end) - neighbourhood(1:end-1)));

    ratio = u1 / u2;

    if ratio >= 0.1
      filtered = [filtered; n];
    else
      ratio
    end
  end
end

% delta = [zeros(50, 1); 1; zeros(50, 1)];

baseline = sig1';
fs = 250;

filteredHaar = haarLikeFilter(baseline, 7, 15);

score = get_score(baseline, filteredHaar);

candiates = local_score_threshold(score, fs);

candiates = adaptive_score_threshold(score, candiates);

candiates = variation_ratio_test(baseline, candiates, fs);



hold on;
plot(baseline);
plot(candiates, baseline(candiates), 'x');


# figure(1);
# plot(sig1);
# hold on
# plot(sig2);

% showSpecsN([ones(4)/4], 512);

pause