USE [Scratch]
GO
EXEC sp_execute_external_script
	@language = N'R',
	@script = N'print("Hello World!")';

USE [Scratch]
GO
-- After using sqlmlutils, we can see external libraries installed.
SELECT * FROM sys.external_libraries_installed eli

-- We can also use these external libraries.
EXEC sp_execute_external_script
	@language = N'R',
	@script = N'library(tidyverse)
	x <- c(1,2,3,4,5)
	print(x %>% sum(.))';
GO
USE [Scratch2]
GO
-- They don't exist in other databases, however.
SELECT * FROM sys.external_libraries_installed eli

-- And we cannot use them from here.
EXEC sp_execute_external_script
	@language = N'R',
	@script = N'library(tidyverse)
	x <- c(1,2,3,4,5)
	print(x %>% sum(.))';
