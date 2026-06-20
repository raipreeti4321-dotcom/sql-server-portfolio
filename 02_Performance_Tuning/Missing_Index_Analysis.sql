SELECT
    DB_NAME(database_id) AS DatabaseName,
    OBJECT_NAME(object_id, database_id) AS TableName,
    equality_columns,
    inequality_columns,
    included_columns,
    user_seeks,
    avg_total_user_cost,
    avg_user_impact
FROM sys.dm_db_missing_index_details mid
JOIN sys.dm_db_missing_index_groups mig
    ON mid.index_handle = mig.index_handle
JOIN sys.dm_db_missing_index_group_stats migs
    ON mig.index_group_handle = migs.group_handle
ORDER BY avg_user_impact DESC;
