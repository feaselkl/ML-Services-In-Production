USE Scratch
GO
SELECT *
FROM sys.dm_external_script_execution_stats
ORDER BY
	counter_value DESC;