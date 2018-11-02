function isgoal = goalreached(current_position, goal_position)
    tolerance = 0.5;
    isgoal = norm(current_position - goal_position) <  tolerance;
end