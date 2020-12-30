function classifier(rec)

# comment this when using matlab
rec = argv(){1, 1}

[detections, count] = readannotations(sprintf('%s.txt', rec));

fprintf('Classifing QRS in record %s\n', rec);

load(sprintf('%sm.mat', rec))

t=cputime();

beats = qrs_classify(val, detections(:, [1, 2]), 250);
fprintf(' running time: %f\n', cputime() - t);
fid = fopen(sprintf('%s.cls',rec), 'wt');
names = ['N', 'V'];
for i=1:size(beats, 1)
  fprintf(fid, '0:00:00.00 %d %s 0 0 0\n', beats(i, 1), names(beats(i, 2) + 1));
end
fclose(fid);
end