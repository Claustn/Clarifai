#requires
#requires -Version 3.0
function Add-ImageFromFileWithConcepts
{
  [CmdletBinding()]
  param
  (
    [string]$ImagePath,
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
	
  $base64 = [convert]::ToBase64String((Get-Content $ImagePath -Encoding byte))

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

  	
  #$jsonbody = [ordered]@{
  #    inputs = @(
  #      @{
  #        data = @{
  #          image = @{
  #            base64 = $base64
  #          }
  #        }
  #      }
  #    )
  #  }  | ConvertTo-Json -Depth 6

	
  $jsonbody = [ordered]@{
    inputs = @(
      @{
        data = @{
          image    = @{
            base64 = $base64
          }
          concepts = @(              
            $Cons              
          )
        }
      }
    )
  }| ConvertTo-Json -Depth 6



 # $jsonbody
  Try 
  {
    $Res = Invoke-RestMethod -Uri $uri -Body $jsonbody -Headers $headers -Method Post -ErrorAction Stop
    $Res
  }
  Catch 
  {    
    $Err = $($_.ErrorDetails.Message| ConvertFrom-Json)
    Write-Host  -Object "$($Err.inputs.status.Description) "    
    Throw $_
  }
}

