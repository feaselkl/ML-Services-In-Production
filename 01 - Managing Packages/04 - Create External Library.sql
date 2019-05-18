-- Demonstrate installation of external libraries.
USE Scratch
GO
IF EXISTS
(
	SELECT 1
	FROM sys.external_libraries el
	WHERE
		el.name = N'benford.analysis'
)
BEGIN
	DROP EXTERNAL LIBRARY [benford.analysis];
END
GO
CREATE EXTERNAL LIBRARY [benford.analysis]
FROM (CONTENT = 'C:/SourceCode/ML-Services-In-Production/01 - Managing Packages/benford.analysis_0.1.4.1.zip')
WITH ( LANGUAGE = 'R' )
GO
SELECT
	*
FROM sys.external_libraries;
GO
