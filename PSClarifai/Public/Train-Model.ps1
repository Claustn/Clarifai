function Train-Model
{
  [CmdletBinding()]
  param
  (
    [string]$ModelName,
    [string]$Token = (Get-ClarifaiToken)    
  )
	
  
	
  $uri = "https://api.clarifai.com/v2/models/$ModelName/versions"
	
  $headers = @{
    Authorization = 'Bearer {0}' -f $Token
    Accept        = 'application/json'
    'Content-Type' = 'application/json'
  }


  Try 
  {
    $Res = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -ErrorAction Stop
    $Res
  }
  Catch 
  {    
    $Err = $($_.ErrorDetails.Message| ConvertFrom-Json)
    Write-Output  -Object "$($Err.inputs.status.Description) "    
    Throw $_
  }
}

