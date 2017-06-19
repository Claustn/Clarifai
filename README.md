# **PSClarifai** #

This is POC code, that I have written to test from basic features of the Clarifai API from PowerShell
We are currently evaluating if Clarifai can help us solve some monitoring issues, so I wrote the code, to at least be able to test basic features from PowerShell

Currently the following cmdlets are available:
- Add-ConceptsToModel
- Add-ImageFromFileWithConcepts
- Add-ImageFromURLWithConcepts
- Get-ClarifaiToken
- Get-Model
- New-Model
- Predict-ImageFromFile
- Predict-ImageFromURL
- Train-Model


## Examples ##
This will store the API access token in a script variable, accesible to all the other cmdlets.

    Get-ClarifaiToken -Client_ID '<Client_ID>' -Client_Secret '<Client_Secret>'

Predict an image  from a URL using the default model

    Predict-ImageFromURL  'http://www.horsechannel.com/images/horse-news-article-images/chestnut-horse-autumn_1000.jpg' 

Predict an image from a local file using the default model

    Predict-ImageFromFile -ImagePath "C:\Downloads\IMG_20170526_103922.jpg"

Predict an image from a local file using custom model


    Predict-ImageFromFile -ImagePath "C:\Downloads\IMG_20170526_103922.jpg" -Model MyModel

Create a new custom model with concepts

    New-Model -ModelName MyModel -Concepts MacBuild,MacBad,MacGood
 
New model with different settings.

    New-Model -ModelName MyModel -Concepts MyStuff,YourStuff -Concepts_Mutually_Exclusive -Closed_Environment

You can also add images and "mark" them with concepts, so you can train the machine learning algorithms, there are two paramters for that "Concepts" and "Not_Concepts".


    Add-ImageFromURLWithConcepts  -ImageURL 'https://s-media-cache-ak0.pinimg.com/736x/a7/61/d3/a761d340d87d888075314872a9b0c56e.jpg' -Concepts 'Mac Boot', 'Mac Good' -Not_Concepts 'Linux Good', 'Windows Good'

You can also add local media and train with those.

    Add-ImageFromFileWithConcepts -ImagePath "C:\temp\mba-dubp-05217 (osx10.10).jpg" -Concepts MacBuild -Not_Concepts MacBad

Add multiple files from a folder

    Get-ChildItem -Path C:\temp\MacBuild\New | ForEach-Object -Process {
      Add-ImageFromFileWithConcepts -ImagePath $_.FullName -Concepts MacBuild -Not_Concepts MacBad, MacGood
    }

Finally you need to train your model

    Train-Model -ModelName MyModel


## ToDo ##

- Make cmdlets accept pipeline input
- Store client access tokens between sessions
- Validate input
- Expand to cover more functionality
- General clean up of code