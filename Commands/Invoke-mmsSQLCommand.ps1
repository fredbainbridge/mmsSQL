function Invoke-mmsSqlCommand {
    <#
    .SYNOPSIS
    Run a SQL query.
    
    .DESCRIPTION
    This can optionally return results.
    
    .EXAMPLE
    Invoke-mmsSqlQuery -Query $query -Connection $connection -CommandTimeout 60
    
    .NOTES
    General notes
    #>
    [OutputType([System.Data.DataTable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Data.SqlClient.SqlConnection]$Connection,

        [Parameter(Mandatory=$true)]
        [string]$Query,

        [Parameter(Mandatory=$false)]
        [int]$CommandTimeout = 30,
        [Parameter(Mandatory=$false)]
        [switch]$ReturnResults
    )
    if($Connection.State -ne "Open") {
        $Connection.Open()

    }
    $SqlCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand -ArgumentList $Query, $Connection
    $SqlCommand.CommandTimeout = $CommandTimeout
    $SqlReader = $SqlCommand.ExecuteReader()
    
    if($ReturnResults) {
        $results = [System.Collections.ArrayList]::new()
        $keepGoing = $true
        while($keepGoing) {
            while($SqlReader.HasRows) {
                $SqlDataTable = New-Object -TypeName "System.Data.DataTable"
                $SqlDataTable.Load($SqlReader)
                $results.Add($SqlDataTable) | Out-Null
            }
            try{
                if(-not $SqlReader.NextResult()){
                    $keepGoing = $false
                }
            }
            catch {
                $keepGoing = $false;
            }
        }
        $SqlReader.Close()
        if($results.Count -eq 1){
            $results[0]
        }
        else{
            $results
        }
    }
}