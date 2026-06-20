SELECT
    r.session_id,
    r.status,
    r.cpu_time,
    r.total_elapsed_time,
    t.text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.total_elapsed_time > 30000
ORDER BY r.total_elapsed_time DESC;
