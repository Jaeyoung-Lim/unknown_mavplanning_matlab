function tsdf_table = truncate_tsdf(tsdf_table, max_val)
unknown_mask = (tsdf_table == -1);
tsdf_table(tsdf_table > max_val) = max_val;
tsdf_table(tsdf_table < -max_val) = -max_val;
tsdf_table(unknown_mask) = -1;
end