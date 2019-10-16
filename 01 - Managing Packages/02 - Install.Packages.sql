-- Demonstrate installation via sp_execute_external_script
-- using install.packages()
-- This technique is NOT recommended beyond SQL Server 2016.
-- For 2017 and 2019, you should use sqlmlutils instead.
USE Scratch
GO
EXEC sp_execute_external_script
	@language = N'R',
	@script = N'install.packages("tidyverse",
        lib="C:/SQLServer/MSSQL15.MSSQLSERVER/R_SERVICES/library",
        repos = "http://cran.us.r-project.org")';
GO
