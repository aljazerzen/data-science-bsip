function detections = qrs_detect(val)

sig1 = val(1, :);
sig2 = val(2, :);
fs = 250;

% inspect = 1779058;
% inpect_from = inspect - fs * 10;
% inpect_to = inspect + fs * 10;

function s = get_score(x, y)
  x_left = [x(2:end); 0];
  x_right = [0; x(1:end-1)];
  x_2 = 2 * x - x_left - x_right;

  c1 = 0.55;

  s = y .* (x + c1 * x_2);
end

function candiates = local_score_threshold(score, fs)
  local_max = movmax(abs(score), round(0.2 * fs));
  qualifies = abs(score) == local_max;
  candiates = find(qualifies);
end

function filtered = adaptive_score_threshold(score, candiates)
  % figure(2);
  % hist(abs(score), 40)
  % pause
  % figure(1);

  T = 1000;

  betta1 = 0.1;
  betta2 = 0.1;

  m1 = -100;
  diffs = [0,0,0,0];

  tau = [6,4,3,2,1];
  tau = tau / sum(tau);

  filtered = [];
  % fprintf("       n       W1      W2         t   score\n")
  for n = candiates'

    sorted_last_10sec = sort(abs(score(max(1,n-fs*10):n)));
    S5 = sorted_last_10sec(max(1, length(sorted_last_10sec)-4));
    W1 = T + S5;

    d = n - m1;
    Ie = sum(tau .* [d, diffs]);
    
    W2 = betta1 + betta2 * abs(d / Ie - round(d / Ie));

    t = W1 * W2;

    % if n >= inpect_from && n<= inpect_to
    %   fprintf("%8d %8.2f %8.2f %8.2f %8.2f\n", n, W1, W2, t, abs(score(n)))
    % end

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

    if ratio >= 0.14
      filtered = [filtered; n];
    % else
      % printf("n = %10d ratio = %0.4f\n", n, ratio)
    end
  end
end

function inspect_plot(style, candiates)
  candiates_to_show = candiates(inpect_from <= candiates & candiates <= inpect_to);
  plot(candiates_to_show - inpect_from, score(candiates_to_show), style);
end

% delta = [zeros(50, 1); 1; zeros(50, 1)];

baseline = hp_filter(sig1, 40, 1/fs)';

filteredHaar = haar_like_filter(baseline, 7, 15);

score = get_score(baseline, filteredHaar);

% close('all');
% figure(1);
% subplot(3, 1, 1);
% plot(sig1(inpect_from:inpect_to)); 
% subplot(3, 1, 2);
% plot(baseline(inpect_from:inpect_to)); 
% subplot(3, 1, 3); hold on;
% plot(score(inpect_from:inpect_to)); 

candiates = local_score_threshold(score, fs);
% inspect_plot('xg', candiates);

candiates = adaptive_score_threshold(score, candiates);
% inspect_plot('xb', candiates);

candiates = variation_ratio_test(baseline, candiates, fs);
% inspect_plot('xr', candiates);

detections = candiates';

% figure(1);
% plot(sig1);
% hold on
% plot(sig2);

% showSpecsN([ones(4)/4], 512);
end