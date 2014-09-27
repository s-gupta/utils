function s = addfield(s, field_name, field_val)
% function s = addfield(s, field_name, field_val)
% Add field_name to all structures in the structure with a value of field_val

% AUTORIGHTS

  tmp = {};
  for i = 1:length(s),
    tmp{i} = field_val;
  end
  [s(:).(field_name)] = deal(tmp{:});
end
