function Get-Model
{
  [CmdletBinding()]
  param
  (
  [string]$Token = (Get-ClarifaiToken) 
  )
	
  
	
  $uri = 'https://api.clarifai.com/v2/models' 
	
  $headers = @{
    Authorization = 'Bearer {0}' -f $Token
    Accept        = 'application/json'
    'Content-Type' = 'application/json'
  }


  Try 
  {
    $Res = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop
    $Res.models
  }
  Catch 
  {    
    $Err = $($_.ErrorDetails.Message| ConvertFrom-Json)
    Write-Host  -Object "$($Err.inputs.status.Description) "    
    Throw $_
  }
}
