-- Demonstrate installation of external libraries.
USE Scratch
GO
CREATE EXTERNAL LIBRARY [benford.analysis]
FROM (CONTENT = 'C:\Temp\benford.analysis_0.1.5.zip')
WITH ( LANGUAGE = 'R' )
