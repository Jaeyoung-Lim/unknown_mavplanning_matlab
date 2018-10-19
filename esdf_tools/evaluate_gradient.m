function [mag_error, dir_error] = evaluate_gradient(gt_grad_x, gt_grad_y, mask, grad_x, grad_y)
gt_grad_x = gt_grad_x(mask);
gt_grad_y = gt_grad_y(mask);
grad_x = grad_x(mask);
grad_y = grad_y(mask);

% Magnitude:
gt_mag = (gt_grad_x.^2 + gt_grad_y.^2).^(1/2);
mag = (grad_x.^2 + grad_y.^2).^(1/2);

gt_dir = atan2(gt_grad_y, gt_grad_x);
dir = atan2(grad_y, grad_x);

mag_error = mean(abs(gt_mag - mag));

dir_error_vec = zeros(size(grad_x));
for i = 1:length(grad_x)
  a = [gt_grad_x(i) gt_grad_y(i)];
  b = [grad_x(i) grad_y(i)];
  costheta = dot(a,b)/(norm(a)*norm(b));
  theta = acos(costheta);
  
  dir_error_vec(i) = theta;
end
%dir_error = mean(abs(wrapToPi(gt_dir - dir)));
dir_error = mean(abs(dir_error_vec(i)));
end