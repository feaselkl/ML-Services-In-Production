USE Scratch
GO
SELECT
    r.session_id,
    r.blocking_session_id,
    r.status,
    DB_NAME(s.database_id) AS database_name,
    s.login_name,
    s.program_name,
    r.wait_time,
    r.wait_type,
    r.last_wait_type,
    r.total_elapsed_time,
    r.cpu_time,
    r.reads,
    r.logical_reads,
    r.writes,
    er.language,
    er.degree_of_parallelism,
    er.external_user_name
FROM sys.dm_exec_requests AS r
    INNER JOIN sys.dm_external_script_requests AS er
        ON r.external_script_request_id = er.external_script_request_id
    INNER JOIN sys.dm_exec_sessions AS s
        ON s.session_id = r.session_id;

/* --Run this in another query window.
USE Scratch
GO
DECLARE
    @sql NVARCHAR(MAX) = N'
SELECT
    pop.City,
    pop.Population
FROM dbo.NorthCarolinaPopulation pop'
exec sp_execute_external_script
    @language = N'R',
    @script = N'
        library(benford.analysis)
        cp <- benford(data = InputDataSet$Population, number.of.digits = 1, sign = "positive", discrete=TRUE, round=3);
        Sys.sleep(15)
        print(cp)',
    @input_data_1 = @sql;
*/