function [S, D_mean, D_stdev, T_mean, T_stdev] = calc_analytics(D, T, S, num_tests, Test_planner, Test_goalselection)
D_mean = zeros(num_tests, 1);
D_stdev = zeros(num_tests, 1);
T_mean = zeros(num_tests, 1);
T_stdev = zeros(num_tests, 1);
S= logical(S);

for k = 1:num_tests
    if sum(S(k, :))>0
        D_mean(k) = mean(D(k, S(k, :)));
        D_stdev(k) = std(D(k, S(k, :)));
        T_mean(k) = mean(T(k, S(k, :)));
        T_stdev(k) = std(T(k, S(k, :)));        
    end
    % Plot messages
    fprintf('--------------------------------------------------\n');
    fprintf('Test case %d: %s , %s\n', k, Test_planner{k}, Test_goalselection{k});
    fprintf('  - Distance Traveled: %d +- %d\n', D_mean(k), D_stdev(k));
    fprintf('  - Time Traveled: %d +- %d\n', T_mean(k), T_stdev(k));
end
end
