function [ cmap ] = create_cmap(white_band)
cmap = colormap(parula(100));
if (white_band) 
  cmap(ceil(end/3), :) = [1 1 1];
  %cmap(ceil(end/3)-1, :) = [1 1 1];
  %cmap(ceil(end/3)+1, :) = [1 1 1];
end
%cmap2 = colormap(hot(100));
%cmap2(:, 1) = 1;
%cmap = cmap2;

temp = cmap(1:floor(end/3), 1); 
cmap(1:floor(end/3), 1) = cmap(1:floor(end/3), 3);
%cmap(1:ceil(end/3)+1, 3) = temp;

% Set the last one to gray for unknown.
cmap(1, :) = [0.75, 0.75, 0.75];
end

