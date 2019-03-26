USE TutorialDB;
GO
--STEP 1 - Setup model table for storing the model
DROP TABLE IF EXISTS rental_models;
GO
CREATE TABLE rental_models
(
    model_name VARCHAR(30) NOT NULL DEFAULT('default model'),
    lang VARCHAR(30),
    model VARBINARY(MAX),
    native_model VARBINARY(MAX),
    PRIMARY KEY (model_name, lang)
);
GO

--STEP 2 - Train model using RevoscaleR
DROP PROCEDURE IF EXISTS generate_rental_R_native_model;
GO
CREATE PROCEDURE generate_rental_R_native_model
(
@model_type varchar(30),
@trained_model varbinary(max) OUTPUT
)
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
        rd.Year < 2015;';

    EXECUTE sp_execute_external_script
      @language = N'R',
      @script = N'
require("RevoScaleR")

rental_train_data$Holiday = factor(rental_train_data$Holiday);
rental_train_data$Snow = factor(rental_train_data$Snow);
rental_train_data$WeekDay = factor(rental_train_data$WeekDay);

if(model_type == "linear") {
	#Create a dtree model and train it using the training data set
	model_dtree <- rxDTree(RentalCount ~ Month + Day + WeekDay + Snow + Holiday, data = rental_train_data);
	trained_model <- rxSerializeModel(model_dtree, realtimeScoringOnly = TRUE);
	}

if(model_type == "dtree") {
	model_linmod <- rxLinMod(RentalCount ~ Month + Day + WeekDay + Snow + Holiday, data = rental_train_data);
	#Before saving the model to the DB table, we need to serialize it. This time, as a native scoring model
	trained_model <- rxSerializeModel(model_linmod, realtimeScoringOnly = TRUE);
	}
',
      @input_data_1 = @SQL,
      @input_data_1_name = N'rental_train_data',
      @params = N'@trained_model varbinary(max) OUTPUT, @model_type varchar(30)',
	  @model_type = @model_type,
      @trained_model = @trained_model OUTPUT;
END;
GO

--STEP 3 - Save model to table

--Line of code to empty table with models
--TRUNCATE TABLE rental_models;

--Save Linear model to table
DECLARE @model VARBINARY(MAX);
EXEC generate_rental_R_native_model "linear", @model OUTPUT;
INSERT INTO rental_models (model_name, native_model, lang) VALUES('linear_model', @model, 'R');

--Save DTree model to table
DECLARE @model2 VARBINARY(MAX);
EXEC generate_rental_R_native_model "dtree", @model2 OUTPUT;
INSERT INTO rental_models (model_name, native_model, lang) VALUES('dtree_model', @model2, 'R');

-- Look at the models in the table
SELECT * FROM rental_models;

GO
-- STEP 4  - Use the native PREDICT (native scoring) to predict number of rentals for both models
--Now lets predict using native scoring with linear model
DECLARE @model VARBINARY(MAX) = (SELECT TOP(1) native_model FROM dbo.rental_models WHERE model_name = 'linear_model' AND lang = 'R');
SELECT d.*, p.* FROM PREDICT(MODEL = @model, DATA = dbo.rental_data AS d) WITH(RentalCount_Pred float) AS p;
GO

--Native scoring with dtree model
DECLARE @model VARBINARY(MAX) = (SELECT TOP(1) native_model FROM dbo.rental_models WHERE model_name = 'dtree_model' AND lang = 'R');
SELECT d.*, p.* FROM PREDICT(MODEL = @model, DATA = dbo.rental_data AS d) WITH(RentalCount_Pred float) AS p;
GO