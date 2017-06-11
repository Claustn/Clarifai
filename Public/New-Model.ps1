function New-Model
{
  [CmdletBinding()]
  param
  (
    [string]$ModelName,
    [string]$Token = (Get-ClarifaiToken),
    [string[]]$Concepts,
    [bool]$Concepts_Mutually_Exclusive = $false,
    [bool]$Closed_Environment = $false    
  )
	
  if ($Concepts_Mutually_Exclusive) 
  {
    $Concepts_Mutually_Exclusive = $true
  } 
  if ($Closed_Environment) 
  {
    $Closed_Environment = $true
  }

	
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
    model = [ordered]@{
      id          = $ModelName
      output_info = [ordered]@{
        data          = @{
          concepts = @(
            $Cons          
          )
        }
        output_config = [ordered]@{
          concepts_mutually_exclusive = $Concepts_Mutually_Exclusive
          closed_environment          = $Closed_Environment
        }
      }
    }
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

