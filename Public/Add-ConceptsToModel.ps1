function Add-ConceptsToModel
{
  [CmdletBinding()]
  param
  (
    [string]$ModelName,
    [string]$Token = (Get-ClarifaiToken),
    [string[]]$Concepts

  )
	

  $uri = 'https://api.clarifai.com/v2/models' 
	
  $headers = @{
    Authorization = 'Bearer {0}' -f $Token
    Accept        = 'application/json'
    'Content-Type' = 'application/json'
  }
	


  $Cons = @()
  Foreach ($Concept in $Concepts) 
  {
    $Cons += New-Object -TypeName PSObject -Property  @{
      id = $Concept
    }
  }
  	
  $jsonbody = [ordered]@{
    models = @([ordered]@{
        id          = $ModelName
        output_info = [ordered]@{
          data = @{
            concepts = @(
              $Cons          
            )
          }
        }
    })
    action = 'merge'
  } | ConvertTo-Json -Depth 6
  
	
  $jsonbody
  Try 
  {
    $Res = Invoke-RestMethod -Uri $uri -Body $jsonbody -Headers $headers -Method Patch -ErrorAction Stop
    $Res
  }
  Catch 
  {    
    $Err = $($_.ErrorDetails.Message| ConvertFrom-Json)
    Write-Host  -Object "$($Err.inputs.status.Description) "    
    Throw $_
  }
}

