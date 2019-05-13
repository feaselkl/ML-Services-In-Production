USE TutorialDB
--Execute the predict_rentals stored proc and pass the modelname and a query string with a set of features we want to use to predict the rental count
EXEC dbo.predict_rentalcount_pkg @model = 'rxDTree',
       @q ='SELECT
    CONVERT(INT, 3) AS Month,
    CONVERT(INT, 24) AS Day,
    CONVERT(INT, 4) AS WeekDay,
    CONVERT(INT, 1) AS Snow,
    CONVERT(INT, 1) AS Holiday';
GO
