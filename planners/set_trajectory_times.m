function trajectory = set_trajectory_times(trajectory, segment_time)
%ESTIMATE_TRAJECTORY_TIMES

[p, v, a] = get_vertex_trajectory(trajectory, 1);

for i = 2 : trajectory.num_elements
  [p_new, v_new, a_new] = get_vertex_trajectory(trajectory, i);
  time = segment_time;
  trajectory = set_trajectory_segment_time(trajectory, i, time);
  p = p_new;
  v = v_new;
  a = a_new;
end

end