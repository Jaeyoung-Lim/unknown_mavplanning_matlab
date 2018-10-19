function [ray_coords] = cast_ray(start_coord, end_coord)

  start_index = round(start_coord);
  end_index = round(end_coord + 1e-2);
  %ray_scaled = end_coord - start_coord;
  ray_scaled = end_index - start_index;
  ray_step_signs = sign(ray_scaled);
  corrected_step = ray_step_signs > 0;
  
  start_scaled_shifted = start_coord - start_index;
  %distance_to_boundaries = [0 0];%corrected_step - start_scaled_shifted;
  if (any(start_scaled_shifted))
    distance_to_boundaries = corrected_step - start_scaled_shifted;
  else
    distance_to_boundaries = [0 0];
  end
  %distance_to_boundaries = ray_step_signs - start_scaled_shifted;
  
  t_to_next_boundary = distance_to_boundaries ./ ray_scaled;
  t_to_next_boundary(isnan(t_to_next_boundary)) = 2;
  
  if (start_index == end_index) 
    return;
  end
  
  t_step_size = ray_step_signs ./ ray_scaled;
  
  curr_index = start_index;
  ray_coords(1, :) = curr_index;
  
  while (any(curr_index ~= end_index))
    [~, ind] = min(t_to_next_boundary);
    
    curr_index(ind) = curr_index(ind) + ray_step_signs(ind);
    t_to_next_boundary(ind) = t_to_next_boundary(ind) + t_step_size(ind);
    
    ray_coords(end+1, :) = curr_index;
    
    if (any(t_to_next_boundary > 1.1 & t_to_next_boundary < 2))
      disp 'Hello'
    end
    % Check if we're behind on the ray.
    %if (dot(curr_index - start_coord, ray_scaled) < 0)
    %  break;
    %end
  end
end