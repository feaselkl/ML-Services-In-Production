USE TutorialDB
GO
-- Stored procedure that trains and generates an R model using the rental_data and a decision tree algorithm
DROP PROCEDURE IF EXISTS generate_rental_rx_model;
go
CREATE PROCEDURE generate_rental_rx_model (@trained_model varbinary(max) OUTPUT)
AS
BEGIN
    DECLARE
        @SQL NVARCHAR(MAX) = N'
    SELECT
        rd."RentalCount",
        rd."Year",
        rd."Month",
        rd."Day",
        rd."WeekDay",
        rd."Snow",
        rd."Holiday"
    FROM dbo.rental_data rd
    WHERE
        rd.Year < 2015;'

    EXECUTE sp_execute_external_script
      @language = N'R',
      @script = N'
        require("RevoScaleR");

        rental_train_data$Holiday = factor(rental_train_data$Holiday);
        rental_train_data$Snow = factor(rental_train_data$Snow);
        rental_train_data$WeekDay = factor(rental_train_data$WeekDay);

        #Create a dtree model and train it using the training data set
        model_dtree <- rxDTree(RentalCount ~ Month + Day + WeekDay + Snow + Holiday, data = rental_train_data);
        #Before saving the model to the DB table, we need to serialize it
        trained_model <- as.raw(serialize(model_dtree, connection=NULL));',

      @input_data_1 = @SQL,
      @input_data_1_name = N'rental_train_data',
      @params = N'@trained_model varbinary(max) OUTPUT',
      @trained_model = @trained_model OUTPUT;
END;
GO