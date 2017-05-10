$string = @'
{
      "models": [
        {
          "id": "{model_id}",
          "output_info": {
            "data": {
              "concepts": [
                {
                  "id": "dogs"
                }
              ]
            }
          }
        }
      ],
      "action": "merge"
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


