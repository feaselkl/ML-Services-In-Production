# Demonstrate installation via the command prompt using rxInstallPackages.
# Navigate to C:\SQL\MSSQL15.MSSQLSERVER\R_SERVICES\bin
# Run R.exe
packagesToInstall <- c("caret", "tree", "party", "data.table", "wkb")
rxInstallPackages(pkgs = packagesToInstall, owner = "", scope = "shared");