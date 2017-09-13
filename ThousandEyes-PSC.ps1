#http://developer.thousandeyes.com/v6/test_data/

Function Get-TETestInfo {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, HelpMessage="Specify the name of the test")]
        [string]$TestName = "Logan's Minecraft Server"
	)
$apiuser = "tylerapplebaum@gmail.com"
$apipassword = "1xviw1h3qt40531eh6q3ddvkt5uqa1jy"
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiuser + ":" + $apipassword))
$headers = @{
	"accept"= "application/json"; 
	"content-type"= "application/json"; 
	"authorization"= "Basic $authorization"
}

$TestsResponse = Invoke-WebRequest https://api.thousandeyes.com/tests.json -Headers $headers
$ParsedContent = ConvertFrom-Json $TestsResponse.Content
$TestID = $ParsedContent.test | Where-Object testName -eq $TestName | Select -ExpandProperty testId
$TestInterval = $ParsedContent.test | Where-Object testName -eq $TestName | Select -ExpandProperty interval
Write-Output $TestID
Write-Output $TestInterval
}


##### Run code below to gather data; append to CSV

$apiuser = "tylerapplebaum@gmail.com"
$apipassword = "1xviw1h3qt40531eh6q3ddvkt5uqa1jy"
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiuser + ":" + $apipassword))

$HeadersTest = @{
	"accept"= "application/json"; 
	"content-type"= "application/json"; 
	"authorization"= "Basic $authorization"
}

$QueryString = @{
	"window" = "7d"
}
$ISO8601_7DaysAgo = Get-Date (Get-Date).AddDays(-7) -format s

$response3 = Invoke-WebRequest "https://api.thousandeyes.com/v6/net/metrics/$TestID" -Headers $HeadersTest -Body $QueryString

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
$jsonserial.MaxJsonLength  = 67108864
$Obj = $jsonserial.DeserializeObject($Response3)

$Obj.net.metrics.date
$Obj.net.metrics.loss
$Obj.net.metrics.jitter
$Obj.net.metrics.minLatency
$Obj.net.metrics.avgLatency
$Obj.net.metrics.maxLatency


