#http://developer.thousandeyes.com/v6/test_data/
#$ISO8601_7DaysAgo = Get-Date (Get-Date).AddDays(-7) -format s

[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, HelpMessage="Specify the API user")]
        [string]$ApiUser = "tylerapplebaum@gmail.com",
		[Parameter(ValueFromPipeline, HelpMessage="Specify the API password")]
		[string]$ApiPassword = "1xviw1h3qt40531eh6q3ddvkt5uqa1jy"
	)

Function script:Get-TETestInfo {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, HelpMessage="Specify the name of the test")]
        [string]$TestName
	)
$Authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($ApiUser + ":" + $ApiPassword))
$Headers = @{
	"accept"= "application/json"; 
	"content-type"= "application/json"; 
	"authorization"= "Basic $Authorization"
}

$TestsResponse = Invoke-WebRequest https://api.thousandeyes.com/tests.json -Headers $headers
$ParsedContent = ConvertFrom-Json $TestsResponse.Content
$TestID = $ParsedContent.test | Where-Object testName -eq $TestName | Select -ExpandProperty testId
$TestInterval = $ParsedContent.test | Where-Object testName -eq $TestName | Select -ExpandProperty interval
Write-Verbose "Selected test ID $TestID"
} #End Get-TETestInfo


Function script:Get-TETestNetMetrics {

$QueryString = @{
	"window" = "7d" #Adjust this based on the amount of data wanted
}

$MetricsResponse = Invoke-WebRequest "https://api.thousandeyes.com/v6/net/metrics/$TestID" -Headers $Headers -Body $QueryString

#PowerShell's native ConvertFrom-Json cuts off the data, so a .NET assembly was used to do it right!
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$JsonSerial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
$JsonSerial.MaxJsonLength  = 67108864
$RawPSObject = $JsonSerial.DeserializeObject($MetricsResponse)

$i = 0 #Count for each item in the array of metric data
$OutputList = New-Object System.Collections.Generic.List[System.Object]
 For ($y = 1; $y -le $RawPSObject.net.metrics.count; $y++){
	$FilteredPSObject = [PSCustomObject]@{
		"Date (UTC)" = $RawPSObject.net.metrics.date[$i]
		"Loss" = $RawPSObject.net.metrics.loss[$i]
		"Jitter" = $RawPSObject.net.metrics.jitter[$i]
		"Avg RTT" = $RawPSObject.net.metrics.avgLatency[$i]
		"Min RTT" = $RawPSObject.net.metrics.minLatency[$i]
		"Max RTT" = $RawPSObject.net.metrics.maxLatency[$i]
	}
$OutputList.Add($FilteredPSObject)
$i++
}
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$OutputList | Export-CSV $DesktopPath\$TestName.csv -NoTypeInformation
  
} #End Get-TETestNetMetrics

. Get-TETestInfo -TestName "Logan's Minecraft Server"
. Get-TETestNetMetrics