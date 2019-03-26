-- NOTE:  change the locations of these before running them or use
-- the SSMS GUI to restore TutorialDB.bak.
USE master;
GO
RESTORE DATABASE TutorialDB
   FROM DISK = 'C:\Temp\TutorialDB.bak'
   WITH
        MOVE 'TutorialDB' TO 'C:\SQL\Data\TutorialDB.mdf',
        MOVE 'TutorialDB_log' TO 'C:\SQL\Logs\TutorialDB.ldf';
GO