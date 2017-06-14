#requires
#requires -Version 3.0
function Add-ImageFromURLWithConcepts
{
  [CmdletBinding()]
  param
  (
    [string]$ImageURL,
    [string]$Token = (Get-ClarifaiToken),
    [string[]]$Concepts,
    [string[]]$Not_Concepts
    
  )
	
	
  $uri = 'https://api.clarifai.com/v2/inputs' 
	
  $headers = @{
    Authorization = 'Bearer {0}' -f $Token
    Accept        = 'application/json'
    'Content-Type' = 'application/json'
  }
	


  $Cons = @()
  Foreach ($Concept in $Concepts) 
  {
    $Cons += New-Object -TypeName PSObject -Property  @{
      id    = $Concept
      value = $true
    }
  }


  Foreach ($Concept in $Not_Concepts) 
  {
    $Cons += New-Object -TypeName PSObject -Property  @{
      id    = $Concept
      value = $false
    }
  }

  	
  $jsonbody = [ordered]@{
    inputs = @(
      [ordered]@{
        data = @{
          image    = @{
            url = $ImageURL
          }
          concepts = @(
            $Cons          
          )
        } 
    })
  } | ConvertTo-Json -Depth 6

	
  Write-Debug -Message $jsonbody
  Try 
  {
    $Res = Invoke-RestMethod -Uri $uri -Body $jsonbody -Headers $headers -Method Post -ErrorAction Stop
    $Res
  }
  Catch 
  {    
    $Err = $($_.ErrorDetails.Message| ConvertFrom-Json)
    Write-Output  -Object "$($Err.inputs.status.Description) "    
    Throw $_
  }
}

