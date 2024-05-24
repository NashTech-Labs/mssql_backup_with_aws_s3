# SQL Server Backup and Upload to AWS S3

This repository contains a PowerShell script to automate the process of backing up a SQL Server database, compressing the backup file using 7-Zip, and uploading it to an AWS S3 bucket. It also includes cleanup steps to remove old backup files.

## Prerequisites

- **AWS Tools for PowerShell**: For setting AWS credentials and uploading files to S3.
- **SQL Server Tools (`sqlcmd`)**: For executing SQL commands to back up the database.
- **7-Zip**: For compressing the backup file.

## Usage

1. **Set Variables**: Update the script with your SQL Server details, AWS credentials, and file paths.
2. **Run the Script**: Execute the script in PowerShell.

## Steps Performed by the Script

1. **Backup the Database**: Uses `sqlcmd` to back up the specified SQL Server database to a `.bak` file.
2. **Compress the Backup File**: Uses 7-Zip to compress the `.bak` file to a `.7z` file.
3. **Upload to AWS S3**: Uploads the compressed backup file to a specified AWS S3 bucket.
4. **Clean Up Old Files**: Deletes backup files and compressed files older than 2 days.

## Notes

- Ensure 7-Zip is installed at the specified path (`C:\Program Files\7-Zip\7z.exe`).
- Replace placeholder values in the script (e.g., SQL Server details, AWS credentials) with actual values before running the script.

---
