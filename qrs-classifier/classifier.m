function classifier(rec)

% comment this out when using matlab
args = argv();
rec = args{1, 1};

fprintf('[classifier] reading annotations\n');
[detections, count] = readannotations(sprintf('%s.txt', rec));

fprintf('[classifier] classifing QRS in record %s\n', rec);

load(sprintf('%sm.mat', rec))

t=cputime();

beats = qrs_classify(val, detections(:, [1, 2]), 250);
fprintf('[classifier] running time: %f\n', cputime() - t);

% write plain-text .cls file
fid = fopen(sprintf('%s.cls',rec), 'wt');
names = ['N', 'V'];
for i=1:size(beats, 1)
  fprintf(fid, '0:00:00.00 %d %s 0 0 0\n', beats(i, 1), names(beats(i, 2) + 1));
end
fclose(fid);

end