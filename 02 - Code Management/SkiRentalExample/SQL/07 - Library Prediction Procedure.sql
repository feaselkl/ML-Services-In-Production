USE TutorialDB
GO
--Stored procedure that takes model name and new data as input parameters and predicts the rental count for the new data
DROP PROCEDURE IF EXISTS predict_rentalcount_pkg;
GO
CREATE PROCEDURE predict_rentalcount_pkg
(
@model VARCHAR(100),
@q NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE
        @rx_model VARBINARY(MAX) = (SELECT model FROM rental_rx_models WHERE model_name = @model);

    EXECUTE sp_execute_external_script
        @language = N'R',
        @script = N'OutputDataSet <- SkiRentalProject::GeneratePredictions(InputDataSet, rx_model);',
        @input_data_1 = @q,
        @params = N'@rx_model varbinary(max)',
        @rx_model = @rx_model
        WITH RESULT SETS
			((RentalCount_Predicted FLOAT));
END;
GO