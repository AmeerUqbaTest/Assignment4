# SQL Database Assignment - PowerShell Execution Script
# Target: Azure MS SQL Server
# Library Management System

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerName,
    
    [Parameter(Mandatory=$true)]
    [string]$DatabaseName,
    
    [string]$Username = $null,
    [string]$Password = $null
)

Write-Host "SQL Database Assignment - Library Management System" -ForegroundColor Green
Write-Host "Target: Azure MS SQL Server" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Build connection string
$connectionArgs = @("-S", $ServerName, "-d", $DatabaseName)

if ($Username -and $Password) {
    $connectionArgs += @("-U", $Username, "-P", $Password)
} else {
    $connectionArgs += "-E"  # Use Windows Authentication
}

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsPath = Join-Path $scriptDir "scripts"

# Define scripts in execution order
$scripts = @(
    @{ Name = "01_DDL_CreateTables.sql"; Description = "Creating database schema (Tasks 1-4)" },
    @{ Name = "02_DML_InsertData.sql"; Description = "Inserting sample data (Tasks 5-9, 24)" },
    @{ Name = "03_Queries_Select.sql"; Description = "Executing queries (Tasks 10-17, 26)" },
    @{ Name = "04_DML_UpdateDelete.sql"; Description = "Data modifications (Tasks 18-21, 27-28)" },
    @{ Name = "05_DDL_Modifications.sql"; Description = "Schema modifications (Tasks 22-23, 25)" }
)

# Execute each script
foreach ($script in $scripts) {
    Write-Host "`nSTEP $($scripts.IndexOf($script) + 1): $($script.Description)" -ForegroundColor Yellow
    
    $scriptPath = Join-Path $scriptsPath $script.Name
    
    if (Test-Path $scriptPath) {
        $fullArgs = $connectionArgs + @("-i", $scriptPath)
        
        try {
            & sqlcmd @fullArgs
            Write-Host "✓ $($script.Name) executed successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Error executing $($script.Name): $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "✗ Script not found: $scriptPath" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "SQL Database Assignment completed successfully!" -ForegroundColor Green
Write-Host "All 29 tasks have been executed." -ForegroundColor Green
Write-Host "`nReview the docs/answers.txt file for detailed explanations" -ForegroundColor Cyan
Write-Host "of all queries and theoretical concepts." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Green

# Examples of how to run this script:
<#
# For local SQL Server with Windows Authentication:
.\Execute-Assignment.ps1 -ServerName "localhost" -DatabaseName "LibraryDB"

# For Azure SQL Database:
.\Execute-Assignment.ps1 -ServerName "your-server.database.windows.net" -DatabaseName "LibraryDB" -Username "your-username" -Password "your-password"

# For SQL Server with SQL Authentication:
.\Execute-Assignment.ps1 -ServerName "localhost" -DatabaseName "LibraryDB" -Username "sa" -Password "your-password"
#>
