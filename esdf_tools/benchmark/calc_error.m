function [error_table, error] = calc_error(gt_table, eval_table)
% General idea: for all table values observed (> -1), get the error
% between gt and eval.
error_table = zeros(size(gt_table));
eval_inds = eval_table > -1;
error_table(eval_inds) = eval_table(eval_inds) - gt_table(eval_inds);

% Then take the average absolute error.
error = sum(sum(abs(error_table))) / nnz(eval_inds);
end