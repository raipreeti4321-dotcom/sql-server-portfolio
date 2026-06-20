/*
Project: High CPU Query Investigation

Purpose:
Identify expensive queries consuming excessive CPU resources.

Useful for:
- Performance tuning
- Production support
- DBA monitoring
*/

SELECT TOP 20
       DB_NAME(st.dbid) AS DatabaseName,
       qs.execution_count,
       qs.total_worker_time / 1000 AS TotalCPU_MS,
       qs.total_elapsed_time / 1000 AS TotalDuration_MS,
       qs.total_logical_reads,
       qs.total_physical_reads,
       qs.creation_time,
       qs.last_execution_time,
       SUBSTRING
       (
           st.text,
           (qs.statement_start_offset/2)+1,
           (
               (
                   CASE qs.statement_end_offset
                       WHEN -1 THEN DATALENGTH(st.text)
                       ELSE qs.statement_end_offset
                   END
                   - qs.statement_start_offset
               )/2
           )+1
       ) AS QueryText
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY qs.total_worker_time DESC;
