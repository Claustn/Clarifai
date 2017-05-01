<#
	.SYNOPSIS
		Perform image prediction by URL to Clarifai
	
	.DESCRIPTION
		A detailed description of the Predict-ImageFromFile function.
	
	.PARAMETER ImagePath
		URL to image file you want to perform analysis on
	
	.PARAMETER Token
		A description of the Token parameter.
	
	.PARAMETER Model
		Default value will search in the General Model of Clarifai
	
	.PARAMETER ImageFile
		A description of the ImageFile parameter.
	
	.EXAMPLE
		PS C:\> Predict-ImageFromFile
	
	.NOTES
		Additional information about the function.
#>
function Predict-ImageFromURL
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$ImageURL,		
		[string]$Token = (Get-ClarifaiToken),
		[Parameter(Mandatory = $false)]
		[string]$Model = 'aaa03c23b3724a16a56b629203edc62c'
	)
	
	$uri = "https://api.clarifai.com/v2/models/$Model/outputs" -f $Model
	
	$headers = @{
		Authorization = 'Bearer {0}' -f $token
		Accept = 'application/json'
		'Content-Type' = 'application/json'
	}
	
	
	
	$jsonbody = @{
		inputs = @(@{
				data = @{
					image = @{
						url = $ImageURL
					}
				}
			})
	} | ConvertTo-Json -Depth 4
	
	
	$Res = Invoke-Restmethod -Uri $uri -Body $jsonbody -Headers $headers -Method Post
	$Res.outputs.data.concepts
}
