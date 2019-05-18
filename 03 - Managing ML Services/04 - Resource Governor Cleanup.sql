USE master
GO
-- Now we want to create a classifier function to split out calls.
-- Start by setting the classifier to NULL.
ALTER RESOURCE GOVERNOR WITH (classifier_function = NULL);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO
DROP FUNCTION IF EXISTS SplitByProgramName;
GO
IF EXISTS
(
	SELECT 1
	FROM sys.dm_resource_governor_workload_groups wg
	WHERE
		wg.name = N'devWorkloadGroup'
)
BEGIN
	DROP WORKLOAD GROUP devWorkloadGroup;
END
GO
IF EXISTS
(
	SELECT 1
	FROM sys.dm_resource_governor_external_resource_pools rp
	WHERE
		rp.name = N'devExternalResourcePool'
)
BEGIN
	DROP EXTERNAL RESOURCE POOL devExternalResourcePool;
END
GO
ALTER RESOURCE POOL "default" WITH (max_memory_percent = 100);
GO
ALTER EXTERNAL RESOURCE POOL "default" WITH (max_memory_percent = 100);
-- Publish our changes.
ALTER RESOURCE GOVERNOR RECONFIGURE;
-- Check that everything looks fine.
SELECT * 
FROM sys.resource_governor_workload_groups;
GO
SELECT *
FROM sys.resource_governor_external_resource_pools;
GO
SELECT *
FROM sys.resource_governor_external_resource_pool_affinity;
GO
