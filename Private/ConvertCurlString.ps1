$string = @'
{
      "inputs": [
        {
          "data": {
            "image": {
              "url": "https://samples.clarifai.com/puppy.jpeg"
            },
            "concepts":[
              {
                "id": "boscoe",
                "value": true
              }
            ]
          }
        }
      ]
    }
'@

$a = $string -replace '{','@{' -replace '\[','@(' -replace '\]',')' -replace '"','' -replace ':',' =' -replace ',',''
$a | clip

$b = @{
      models = @(
        @{
          id = "hest"
          output_info = @{
            data = @{
              concepts = @(
                @{
                  id = "dogs"
                }
              )
            }
          }
        }
      )
      action = "merge"
    } | convertto-json -Depth 6
    $b


#$a | clip
#$string| convertto-json -Depth 6
#$string''



