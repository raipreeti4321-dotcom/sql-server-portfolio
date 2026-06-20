SELECT
    OBJECT_NAME(object_id) AS TableName,
    index_id,
    avg_fragmentation_in_percent,
    page_count
FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
)
WHERE avg_fragmentation_in_percent > 30
ORDER BY avg_fragmentation_in_percent DESC;
