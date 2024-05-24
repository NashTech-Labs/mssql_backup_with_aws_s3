# Set the timestamp format for backup file naming
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Define paths for the backup file and zip file
$backupDir = "E:\Backup"
$backupFile = "$backupDir\DbBackup_$timestamp.bak"
$zipFile = "E:\Backupofdb\DbBackup_$timestamp.7z"

# Define AWS S3 bucket name
$s3Bucket = "test"

# Define AWS credentials
$accessKey = "------"
$secretKey = "-------"

# Set AWS Credentials
Set-AWSCredentials -AccessKey $accessKey -SecretKey $secretKey -StoreAs default

# Create backup directory if it doesn't exist
if (-Not (Test-Path -Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir
}

# Define SQL Server connection parameters
$sqlServer = "-----------------"        # Replace with your SQL Server name
$database = "-----------------"         # Replace with your database name
$username = "-----------------"         # Replace with your SQL Server username
$password = "-----------------"         # Replace with your SQL Server password

# Backup the database using sqlcmd
Write-Output "Backing up the database..."
$backupCommand = "BACKUP DATABASE [$database] TO DISK = N'$backupFile' WITH NOFORMAT, NOINIT, NAME = N'$database-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
sqlcmd -S $sqlServer -U $username -P $password -Q $backupCommand
Write-Output "Database backup completed."

# Compress the backup file using 7-Zip
Write-Output "Compressing the backup file..."
Start-Process "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-t7z", "$zipFile", "$backupFile" -NoNewWindow -Wait
Write-Output "Compression completed."

# Define the final directory for the compressed backup
$finalCopy = "E:\BackupofDotDatabaseBak"

# Upload the zip file to S3
Write-Output "Uploading the zip file to S3..."
Write-S3Object -BucketName $s3Bucket -Folder $finalCopy -KeyPrefix $finalCopy -Recurse -Force
Write-Output "Upload completed."

# Clean up old backup files (older than 2 days) in the original backup directory
Write-Output "Cleaning up old backup files in the original backup directory..."
Get-ChildItem -Path $backupDir -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-2) } | Remove-Item -Force
Write-Output "Cleanup completed in the original backup directory."

# Clean up old compressed backup files (older than 2 days) in the compressed backup directory
Write-Output "Cleaning up old compressed backup files in the compressed backup directory..."
Get-ChildItem -Path $finalCopy -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-2) } | Remove-Item -Force
Write-Output "Cleanup completed in the compressed backup directory."
