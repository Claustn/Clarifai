function Get-ClarifaiToken
{
  [CmdletBinding()]
  [OutputType([string])]
  param
  (
    [string]$Client_ID,
    [string]$Client_Secret,
    [switch]$Renew
  )

  $uri = 'https://api.clarifai.com/v2/token/'
  $keypair = "$($Client_ID):$($Client_Secret)"	
  $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($keypair))
  $basicAuthValue = "Basic $encodedCreds"	
  $Headers = @{
    Authorization = $basicAuthValue
  }
 
  if ($Script:PSClarifai.ExpiryTime) 
  {
    if ((Get-Date) -lt ($Script:PSClarifai.ExpiryTime)) 
    {
      Write-Verbose -Message 'Token not expired, returning $Script:PSClarifai.Token'
  
      
      $Script:PSClarifai.Token
    }
    Else 
    {
      Write-Verbose -Message 'Token expired, requesting new token and updating $Script:PSClarifai.Token'
      $Res = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post
      $Script:PSClarifai  = New-Object -TypeName PSObject -Property  @{
        ExpiryTime = $((Get-Date).AddSeconds($Res.expires_in))
        Token      = $Res.access_token
      }
      $Script:PSClarifai.Token
    }
  }
  Else 
  {
    Write-Verbose -Message 'No Token set requesting new token and setting $Script:PSClarifai.Token'
    $Res = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post
    
    $Script:PSClarifai  = New-Object -TypeName PSObject -Property  @{
      ExpiryTime = $((Get-Date).AddSeconds($Res.expires_in))
      Token      = $Res.access_token
    }
    $Script:PSClarifai.Token
  }
}
