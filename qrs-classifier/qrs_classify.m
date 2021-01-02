function beats = qrs_classify(signals, beats, fs)

% pkg load signal;

sig = signals(1, :)';

% drift supression with FIR filter
% c1 = 0.97309;
% c2 = 0.94618;
% a = [1, -c2];
% b = [c1, -c1];
% sig_n = filter(b, a, sig);
% won't work: non-linear phase spectrum
% plot(sig); hold on; plot(sig_n)

% 'mean beat' estimation
before = fs * 0.08; % 80ms
after = fs * 0.1;   % 100ms

function s = normalize_isoelectric_est(s)
  offsets_ms = [72, 68, 64, 60];
  offsets_idx = before - fs * offsets_ms / 1000;
  ismetric_est = mean(s(offsets_idx));
  s = s - ismetric_est; 
end

function s = normalize(s)
  s = (s - mean(s)) / sqrt(var(s));
end

function mean_beat = compute_mean_beat(take_first)
  mean_beat = zeros(before + after + 1, 1);
  
  % figure; hold on;
  for j = 1:take_first
    beat_idx = beats(j,1);
    if beat_idx-before > 0 && beat_idx+after <= length(sig)
      beat_sig = normalize(sig(beat_idx-before:beat_idx+after));
      % plot(1:(before + after + 1), beat_sig, 'LineWidth', 2)
      mean_beat = mean_beat + beat_sig;
    end
  end
  % plot((before+1) * ones(6, 1), -2:3)
  % pause
  mean_beat = mean_beat / take_first;
end

function save_beat_distances(beats, sig, mean_beat)
  distances = double([beats zeros(length(beats), 4)]);

  for i = 1:size(beats, 1)
    beat_idx = beats(i, 1);
    if beat_idx-before > 0 && beat_idx+after <= length(sig)
      beat_sig = normalize(sig(beat_idx-before:beat_idx+after));
      
      dist = abs(beat_sig - mean_beat);
      n = length(dist);

      distance_1 = sum(dist) / n;
      distance_2 = sqrt(sum(dist.^2) / n);
      distance_inf = max(dist);

      S_b = sum((beat_sig - mean(beat_sig)).^2);
      S_m = sum((mean_beat - mean(mean_beat)).^2);
      r = sum((beat_sig - mean(beat_sig)) .* (mean_beat - mean(mean_beat))) / sqrt(S_b * S_m);
      distance_r = min(1, 1-r);

      distances(i, 3) = distance_1;
      distances(i, 4) = distance_2;
      distances(i, 5) = distance_inf;
      distances(i, 6) = distance_r;
    end
  end

  dlmwrite('beat-distances.csv', distances, 'delimiter', ',', '-append')
end

function beats = classify(beats, sig, mean_beat, threshold)
  beats = double([beats(:,1) zeros(length(beats), 1)]);

  for i = 1:size(beats, 1)
    beat_idx = beats(i, 1);
    if beat_idx-before > 0 && beat_idx+after <= length(sig)
      beat_sig = normalize(sig(beat_idx-before:beat_idx+after));
      
      dist = abs(beat_sig - mean_beat);
      n = length(dist);

      distance_1 = sum(dist) / n;

      if (distance_1 > threshold)
        % mark as PVC
        beats(i, 2) = 1;
      end
    end
  end
end

mean_beat = compute_mean_beat(10);

% figure; plot(mean_beat, 'LineWidth', 2);
% pause
% save_beat_distances(beats, sig, mean_beat)

beats = classify(beats, sig, mean_beat, 0.43);

end