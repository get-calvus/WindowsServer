<# 
The Best Practices Analyzer (BPA) is a tool built into Windows Server that checks whether certain configurations (mainly roles) comply with best practices.
It can be interesting to check, for the best practices available, whether you comply with them.
These best practices do not have to be respected it is up to you to judge, if in your context, they seem relevant to you.
#>

# List available BPA.
Get-BpaModel | Select-Object -Property Name, Id, LastScanTime

# But a few more are listed as follows
Get-WindowsFeature | Where-Object { $_.BestPracticesModelId -ne '' } | Select-Object -Property name, BestPracticesModelId

# Run an analysis using the ID
# If the role/functionality is not installed on the server, you will get an error
Invoke-BpaModel -ModelId 'Microsoft/Windows/DirectoryServices'

# Run an analysis of all the BPAs for which the role is installed on the workstation
Get-WindowsFeature | Where-Object {($_.BestPracticesModelId -ne '') -and ($_.'InstallState' -eq 'installed')} | Invoke-BpaModel

# Display the result of the analysis
Get-BpaResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object Resolution -ne $null | Select-Object -Property severity, Problem, Resolution,help

# Display results classified as errors or warnings
Get-BpaResult -ModelId 'Microsoft/Windows/DirectoryServices' | Where-Object { $_.severity -match 'warning| error' }

# Display the result of the analysis in an interactive table
Get-BpaResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object Resolution -ne $null | Out-GridView

# Export results as CSV
Get-BpaResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object Resolution -ne $null | Export-Csv -path c:\bpa_results.csv

# Export results in html
Get-BpaResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object Resolution -ne $null | ConvertTo-Html > c:\bpa_results.html

# Exclude results
# Exclusion will only make elements invisible in the graphical interface (in the server manager).
# You need to filter the rules you wish to exclude
Get-BPAResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object { $_.RuleID -eq 44} | Set-BPAResult -Exclude $true

# Another example
Get-BPAResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object { $_.Severity -eq "Information"} | Set-BPAResult -Exclude $true

# Remove the exclusion
Get-BPAResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object { $_.RuleID -eq 44} | Set-BPAResult -Exclude $false

# Another example
Get-BPAResult -ModelID Microsoft/Windows/DirectoryServices | Where-Object { $_.Severity -eq "Information"} | Set-BPAResult -Exclude $false