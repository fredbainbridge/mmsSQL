function New-mmsSqlConnection {
    <#
    .SYNOPSIS
    Create Microsoft SQL Server connection object.
    
    .DESCRIPTION
    This is a wrapper for connecting to sql.
    
    .EXAMPLE
    New-mmsSQLConnection -ServerName "server123" -Databasename "cas_10" -ConnectionTimeout 30
    
    .NOTES
    This assumes integrated security.
    #>
    [OutputType([System.Data.SqlClient.SqlConnection])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServerName,

        [Parameter(Mandatory=$false)]
        [string]$DatabaseName,

        [Parameter(Mandatory=$false)]
        [int]$ConnectionTimeout = 30
    )
    $connection = New-Object -TypeName "System.Data.SqlClient.SqlConnection"
    $ConnectionString = "Server=$ServerName;Integrated Security=true;Connection Timeout=$ConnectionTimeout"
    if($DatabaseName) {
        $ConnectionString = "$ConnectionString;Database=$DatabaseName;Integrated Security=true;Connection Timeout=$ConnectionTimeout"
    }
    $connection.ConnectionString = $ConnectionString
    $connection
}