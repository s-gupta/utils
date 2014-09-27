function f = fullfile_ext(varargin)
% function f = fullfile_ext(varargin)
% f = sprintf('%s.%s', fullfile(varargin{1:end-1}), varargin{end});

% AUTORIGHTS

  f = sprintf('%s.%s', fullfile(varargin{1:end-1}), varargin{end});
end
