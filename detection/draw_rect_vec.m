function I = draw_rect_vec(I, bbox, color, width)
% function I = draw_rect_vec(I, bbox, color, width)
  xmin=bbox(1,:);
  ymin=bbox(2,:);
  w=bbox(3,:)-bbox(1,:)+1;
  h=bbox(4,:)-bbox(2,:)+1;

  mask = false(size(I(:,:,1)));

  %draw horizontal lines
  startx=max(floor(xmin-width/2),1);
  endx=min(ceil(xmin+w+width/2), size(I,2));

  starty=max(floor(ymin-width/2),1);
  endy=max(ceil(ymin+width/2),1);
  for i = 1:length(starty),
    mask(starty(i):endy(i), startx(i):endx(i)) = true;
  end

  starty=min(floor(ymin+h-width/2),size(I,1));
  endy=min(ceil(ymin+h+width/2),size(I,1));
  for i = 1:length(starty),
    mask(starty(i):endy(i), startx(i):endx(i)) = true;
  end

  %draw vertical lines
  starty=max(floor(ymin-width/2),1);
  endy=min(ceil(ymin+h+width/2), size(I,1));

  startx=max(floor(xmin-width/2),1);
  endx=max(ceil(xmin+width/2),1);
  for i = 1:length(starty),
    mask(starty(i):endy(i), startx(i):endx(i)) = true;
  end

  startx=min(floor(xmin+w-width/2),size(I,2));
  endx=min(ceil(xmin+w+width/2),size(I,2));
  for i = 1:length(starty),
    mask(starty(i):endy(i), startx(i):endx(i)) = true;
  end

  % Paint in the image
  for i = 1:numel(color),
    Ii = I(:,:,i);
    Ii(mask) = color(i);
    I(:,:,i) = Ii;
  end
end
