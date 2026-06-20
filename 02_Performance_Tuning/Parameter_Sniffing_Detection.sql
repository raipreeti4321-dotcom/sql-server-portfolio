SELECT
    qs.execution_count,
    qs.min_elapsed_time,
    qs.max_elapsed_time,
    st.text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE qs.max_elapsed_time >
      (qs.min_elapsed_time * 10)
ORDER BY qs.max_elapsed_time DESC;
