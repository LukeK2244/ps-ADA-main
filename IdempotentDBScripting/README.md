> **Before proceeding**
>
> Copy the folder `mssql`, `mysql-maria` or `oracle` (depending on your database vendor) to your own project's repo.
>
> Some of the default scripts in this repo use a placeholder prefix of "AAA". Replace the text "AAA" with your application prefix within the contents of this package.



# RAS Database Repo
Repo for RAS database artifacts

## Idempotent Database Scripts
* All scripts in this repo should be idempotent, allowing the master SQL script to be executed repeatedly on any database environment to migrate it to the latest version.
* Helper functions (with the IDEM_ prefix) are provided to make this simpler for the developer.
* Examples of how to write use the idempotent script framework are provided in `CHEAT_SHEET.sql`.

## How to build a master SQL script
* Run the Powershell script `build-master.ps1`.
* The `RAS-master.sql` file will be overwritten with the latest DB scripts, extracted in order from the folders in the current directory.
* Use only the master SQL script for deployment.
