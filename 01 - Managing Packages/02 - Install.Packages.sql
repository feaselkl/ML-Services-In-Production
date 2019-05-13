-- Demonstrate installation via sp_execute_external_script
-- using install.packages()
USE Scratch
GO
EXEC sp_execute_external_script
	@language = N'R',
	@script = N'install.packages("tidyverse",
        lib="C:/SQL/MSSQL15.MSSQLSERVER/R_SERVICES/library",
        repos = "http://cran.us.r-project.org")';
GO