<#
    .SYNOPSIS
    Upload image to Clarifai
	
    .DESCRIPTION
    A detailed description of the Predict-ImageFromFile function.
	
    .PARAMETER ImageFile
    A description of the ImageFile parameter.
	
    .PARAMETER Token
    A description of the Token parameter.
	
    .PARAMETER Model
    Default value will search in the General Model of Clarifai
	
    .EXAMPLE
    PS C:\> Predict-ImageFromFile
	
    .NOTES
    Additional information about the function.
#>
function Predict-ImageFromFile
{
  [CmdletBinding()]
  param
  (
    [string]$ImagePath,
    [string]$Token = (Get-ClarifaiToken),
    [string]$Model = 'aaa03c23b3724a16a56b629203edc62c'
  )
	
	
  $uri = "https://api.clarifai.com/v2/models/$Model/outputs" -f $Model
	
  $headers = @{
    Authorization = 'Bearer {0}' -f $Token
    Accept        = 'application/json'
    'Content-Type' = 'application/json'
  }
	
  $base64 = [convert]::ToBase64String((Get-Content $ImagePath -Encoding byte))
	
  $jsonbody = @{
    inputs = @(@{
        data = @{
          image = @{
            base64 = $base64
          }
        }
    })
  } | ConvertTo-Json -Depth 4
	
	
  $Res = Invoke-RestMethod -Uri $uri -Body $jsonbody -Headers $headers -Method Post 
  $Res.outputs.data.concepts
}
