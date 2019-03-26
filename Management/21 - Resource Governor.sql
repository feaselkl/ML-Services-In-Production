USE master
GO
-- Set SQL Server to take no more than 60% of the max server memory setting.
ALTER RESOURCE POOL "default" WITH (max_memory_percent = 60);
GO
-- Allow external resources to use no more than 40% of total RAM.
-- This is NOT a case where 60% + 40% = 100%!
ALTER EXTERNAL RESOURCE POOL "default" WITH (max_memory_percent = 40);
-- Publish our changes.
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO
SELECT *
FROM sys.resource_governor_resource_pools;

SELECT *
FROM sys.dm_resource_governor_external_resource_pools;