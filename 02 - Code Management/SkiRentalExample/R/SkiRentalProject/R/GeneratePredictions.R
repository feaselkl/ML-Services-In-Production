#The InputDataSet contains the new data passed to this stored proc. We will use this data to predict.
GeneratePredictions <- function(inputDataSet, model) {
  require("RevoScaleR");

  rentals = inputDataSet;

  #Convert types to factors
  rentals$Holiday = factor(rentals$Holiday);
  rentals$Snow = factor(rentals$Snow);
  rentals$WeekDay = factor(rentals$WeekDay);

  #Before using the model to predict, we need to unserialize it
  rental_model <- unserialize(model);

  print(rental_model)

  rxPredict(modelObject = rental_model, data = rentals);
}
