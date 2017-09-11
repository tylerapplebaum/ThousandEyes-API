#####################
$response0 = Invoke-RestMethod -Uri https://api.thousandeyes.com/status.json -Method GET

#####################

$apiuser = "noreply@thousandeyes.com"
$apipassword = "g351mw5xqhvkmh1vq6zfm51c62wyzib2"
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiuser + ":" + $apipassword))
$headers = @{"accept"= "application/json"; "content-type"= "application/json"; "authorization"= "Basic " + $authorization}
$response = Invoke-WebRequest https://api.thousandeyes.com/agents.json -Headers $headers
$ParsedContent = ConvertFrom-Json $Response.Content

#####################
$apiuser = "noreply@thousandeyes.com"
$apipassword = "g351mw5xqhvkmh1vq6zfm51c62wyzib2"
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiuser + ":" + $apipassword))

$headers = @{
	"accept"= "application/json"; 
	"content-type"= "application/json"; 
	"authorization"= "Basic $authorization"
}

$TestID = "817"
$response3 = Invoke-RestMethod "https://api.thousandeyes.com/web/http-server/$TestID.json" -Method GET -Headers $Headers

#####################
$Data = @{
	agentId='410'
	url='www.thousandeyes.com'
	
}

$json = $Data | ConvertTo-Json
$response3 = Invoke-RestMethod 'https://api.thousandeyes.com/instant/web/http-server.json' -Method POST -Body $json -Headers $Headers

#####################
$apiuser = "noreply@thousandeyes.com"
$apipassword = "g351mw5xqhvkmh1vq6zfm51c62wyzib2"
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiuser + ":" + $apipassword))

$headers = @{
	"accept"= "application/json"; 
	"content-type"= "application/json"; 
	"authorization"= "Basic $authorization"
}

$TestID = "1137"
$PrefixID = "27"
$RoundID = "1413225900"
$response3 = Invoke-RestMethod "https://api.thousandeyes.com/v6/net/bgp-routes/$TestID/$PrefixID/$RoundID.json" -Method GET -Headers $Headers
#####################