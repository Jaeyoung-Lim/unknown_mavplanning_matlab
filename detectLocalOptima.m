function flag = detectLocalOptima(localpath)
%% Detect local planner is stuck in local minima

if norm(localpath(1, :) - localpath(end, :)) < 0.5
    flag = true;
else
    flag = false;
end

end