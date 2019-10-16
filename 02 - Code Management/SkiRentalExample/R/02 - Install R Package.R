# Demonstrate installation via sqlmlutils.
# Refer to 00 - Running sqlmlutils.R for installation instructions and basics.

library(sqlmlutils)
db_connection <- connectionInfo(server = "localhost", database = "TutorialDB")

# Run this only if you have the ski rental project already installed:
sql_remove.packages(
  connectionString = db_connection,
  pkgs = "SkiRentalProject",
  dependencies = FALSE,
  checkReferences = TRUE,
  scope = "PUBLIC",
  verbose = TRUE
)

sql_install.packages(
  connectionString = db_connection,
  pkgs = "../SkiRentalProject_0.1.0.zip",
  verbose = TRUE,
  scope = "PUBLIC",
  repos = NULL
)
