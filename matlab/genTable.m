function lOut = genTable(A,left,top,title,toString,bold)
%function lOut = genTable(A,left,top,title,toString)
%Input
%   A is the matrix to generate the table from
%   left, the left labels
%   top, the top lables
%   title, the title of the table
%   toString, the function to conver thte entries of the matrix A into str
%Output
%   the String to copy paste into latex

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Saurabh Gupta
% 
% This file is part of the Utils code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

	lOut = '';
	lOut = sprintf('%s \n\n\\begin{table}',lOut);
	lOut = sprintf('%s \n\\caption{%s}',lOut,title);
	lOut = sprintf('%s \n\\begin{center}',lOut);

	width = size(A,2)+1;
	height = size(A,1)+1;

	lOut = sprintf('%s \n\n\\begin{tabular}{c|',lOut);
	for i=2:width,
		lOut = sprintf('%sc',lOut);
	end
% 	lOut = sprintf('%s}\n\n\\hline',lOut);
	lOut = sprintf('%s}\n\n',lOut);

	%Generate the header
	lOut = sprintf('%s\n\n   ',lOut);
	lOut = sprintf('%s\n\n %14s',lOut,'');
	for i=1:width-1,
		if(size(top,2) >= i),
			lOut = sprintf('%s & %s',lOut,top{i});
		else
			lOut = sprintf('%s & ',lOut);
		end
	end
	lOut = sprintf('%s \\\\ \\hline',lOut);

	%Put the data into it
	for i = 1:(height-1),
		if(i <= length(left))
			lOut = sprintf('%s\n %14s',lOut,left{i});
		else
			lOut = sprintf('%s\n %14s',lOut, '');
		end
		for j=1:(width-1),
			if(exist('bold', 'var') && bold(i,j))
        lOut = sprintf('%s & \\textbf{%s}',lOut,toString(A(i,j)));
      else
			  lOut = sprintf('%s & %s',lOut,toString(A(i,j)));
      end
		end

% 		lOut = sprintf('%s \\\\ \\hline',lOut);
		lOut = sprintf('%s \\\\ ',lOut);
	end	

	lOut = sprintf('%s \n\n\\end{tabular}',lOut);
	lOut = sprintf('%s \n\\end{center}',lOut);
	lOut = sprintf('%s \n\\label{LABELHERE}',lOut);
	lOut = sprintf('%s \n\\end{table}',lOut);
end
