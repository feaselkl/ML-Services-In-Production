# sqlmlutils installation instructions at https://docs.microsoft.com/en-us/sql/advanced-analytics/package-management/install-additional-r-packages-on-sql-server?view=sql-server-2017
# sqlmlutils details at https://github.com/microsoft/sqlmlutils/tree/master/R

# Step 1, installation:
# Download the zip file from https://github.com/Microsoft/sqlmlutils/tree/master/R/dist
# I'll assume you downloaded to C:\temp\sqlmlutils_0.7.1.zip.
if (!require(RODBCext))
{
  install.packages("RODBCext", repos = "https://cran.microsoft.com")
}
install.packages("C:\\temp\\sqlmlutils_0.7.1.zip", repos = NULL)

library(sqlmlutils)

# NOTE:  need to do this for *each* database!
db_connection <- connectionInfo(driver = "ODBC Driver 17 for SQL Server", server = "localhost", database = "Scratch")

# Install one package.
sql_install.packages(
  connectionString = db_connection,
  pkgs = "tidyverse",
  scope = "PUBLIC",
  verbose = TRUE
)
# Install multiple packages.
sql_install.packages(
  connectionString = db_connection,
  pkgs = c("forecast", "wkb", "data.table", "zoo"),
  scope = "PUBLIC",
  verbose = TRUE
)

# This is a "safe," rerunnable installation.
sql_install.packages(
  connectionString = db_connection,
  pkgs = c("forecast", "wkb", "data.table", "zoo"),
  scope = "PUBLIC",
  verbose = TRUE
)

# Remove packages
sql_remove.packages(
  connectionString = db_connection,
  pkgs = c("zoo", "wkb"),
  scope = "PUBLIC",
  verbose = TRUE
)

# Review packages which we have already installed
r <- sql_installed.packages(connectionString = db_connection, fields=c("Package", "Version", "LibPath", "Attributes", "Scope"))
View(r)

# This works for custom packages as well.
sql_install.packages(
  connectionString = db_connection,
  pkgs = "C:/Temp/MyCustomPackage/binary/MyCustomPackage_0.1.0.zip",
  verbose = TRUE,
  scope = "PUBLIC",
  repos = NULL
)
sql_remove.packages(
  connectionString = db_connection,
  pkgs = "MyCustomPackage",
  dependencies = FALSE,
  checkReferences = TRUE,
  scope = "PUBLIC",
  verbose = TRUE
)
