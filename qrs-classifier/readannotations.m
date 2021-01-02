function [beats, count] = readannotations(file)
  % example use which returns table and number of heart beats
  % [beats, count] = readannotations('100.txt');
  
  % file must contain the full filename of the text file that was created
  % using rdann (e.g. rdann -r 100 -a atr -p N V >100.txt)
  beats = []; count = 0;
  
  fid = fopen(file);
  
  end_of_date = -1;

  while (~feof(fid))
    count = count + 1;
    line = fgetl(fid);
    
    if end_of_date < 0
      double_spaces = strfind(line, "  ");
      end_of_date = min(double_spaces(double_spaces > 8)) + 2;
    end
    z = textscan(line(end_of_date:end), '%d %s %d %d %d');

    idx = z(1);        % extract the sample index
    idx = idx{1};
    typ = z(2);        % extract the sample index
    typ = typ{1};
    if (strcmp(typ,'N')) 
      typ = 0;            % normal (N) heart beats will be returned as 0
    else 
      typ = 1;            % PVC (V) heart beats will be returned as 1
    end;
    
    % add row to heart beat matrix that will be returned
    beats = [beats; [idx,typ]];    
  end
  
  % close the input file
  fclose(fid);
end
