USE master
GO
-- Now we want to create a classifier function to split out calls.
-- Start by setting the classifier to NULL.
ALTER RESOURCE GOVERNOR WITH (classifier_function = NULL);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO
CREATE FUNCTION SplitByProgramName()
RETURNS sysname
WITH schemabinding
AS
BEGIN
    IF program_name() in ('Microsoft R Host', 'RStudio', 'azdata-Query') RETURN 'devWorkloadGroup';
    RETURN 'default'
    END;
GO
ALTER RESOURCE GOVERNOR WITH  (classifier_function = dbo.SplitByProgramName);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO
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
