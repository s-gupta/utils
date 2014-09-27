function plotDS(ds, c)
% function plotDS(ds, c)
	x1 = ds(1); x2 = ds(3); y1 = ds(2); y2 = ds(4);
	line([x1 x1 x2 x2 x1 x1]', [y1 y2 y2 y1 y1 y2]', 'color', c, 'linewidth', 3);
end
