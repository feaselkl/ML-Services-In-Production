USE TutorialDB
GO
--Stored procedure that takes model name and new data as input parameters and predicts the rental count for the new data
DROP PROCEDURE IF EXISTS predict_rentalcount_new;
GO
CREATE PROCEDURE predict_rentalcount_new
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
        @script = N'
            require("RevoScaleR");

            #The InputDataSet contains the new data passed to this stored proc. We will use this data to predict.
            rentals = InputDataSet;

            #Convert types to factors
            rentals$Holiday = factor(rentals$Holiday);
            rentals$Snow = factor(rentals$Snow);
            rentals$WeekDay = factor(rentals$WeekDay);

            #Before using the model to predict, we need to unserialize it
            rental_model = unserialize(rx_model);

            #Call prediction function
            rental_predictions = rxPredict(rental_model, rentals);',
        @input_data_1 = @q,
        @output_data_1_name = N'rental_predictions',
        @params = N'@rx_model varbinary(max)',
        @rx_model = @rx_model
                WITH RESULT SETS (("RentalCount_Predicted" FLOAT));

END;
GO