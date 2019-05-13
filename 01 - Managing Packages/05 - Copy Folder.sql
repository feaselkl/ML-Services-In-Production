-- Demonstrate installation via folder copy-pasta.
-- Steps:  run this first to show the error.
-- Then extract gapminder from its zip file.
-- Then copy gapminder over to the R library.
-- Then run this again and have great success.
USE Scratch
GO
EXECUTE sp_execute_external_script
 @language = N'R',
 @script = N'
 library(gapminder)

 head(gapminder)
 ';
GO