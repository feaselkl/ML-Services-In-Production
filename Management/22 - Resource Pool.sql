USE master
GO
-- Keep those pesky devs off my lawn.
CREATE EXTERNAL RESOURCE POOL devExternalResourcePool WITH (max_memory_percent = 10);
GO
-- Assign devs to use the default resource pool for SQL queries but our dev pool for external requests.
CREATE WORKLOAD GROUP devWorkloadGroup WITH (importance = medium) USING "default", EXTERNAL "devExternalResourcePool";
GO
