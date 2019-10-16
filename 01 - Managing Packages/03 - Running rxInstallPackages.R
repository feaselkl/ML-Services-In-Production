# Demonstrate installation via the command prompt using rxInstallPackages.
# This technique is NOT recommended beyond SQL Server 2016.
# For 2017 and 2019, you should use sqlmlutils instead.
# Navigate to C:\SQL\MSSQL15.MSSQLSERVER\R_SERVICES\bin
# Run R.exe
packagesToInstall <- c("caret", "tree", "party", "data.table", "wkb")
rxInstallPackages(pkgs = packagesToInstall, owner = "", scope = "shared");