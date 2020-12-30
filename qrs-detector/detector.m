function detector(rec)

fprintf('Detecting QRS in record %s\n', rec);

fileName = sprintf('%sm.mat', rec);
t=cputime();

load(fileName)

idx = qrs_detect(val);
fprintf('Running time: %f\n', cputime() - t);
asciName = sprintf('%s.asc',rec);
fid = fopen(asciName, 'wt');
for i=1:size(idx,2)
  fprintf(fid,'0:00:00.00 %d N 0 0 0\n', idx(1,i) );
end
fclose(fid);
