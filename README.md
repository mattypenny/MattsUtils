The intention of this module is that it's going to combine SQLStuff, WindowsStuff, PersonalStuff and maybe bits of other things like SHCommonFunctions and Checksystems

Anything in here should be:

* sterile i.e. no server names etc
* pwsh7 compatible



FRom AI

Get an App Token: First, generate an app token from your Micro.blog account settings.
Query the Media Endpoint: Use the following PowerShell script to get the media endpoint:
```
$token = "YOUR_APP_TOKEN"
$headers = @{
    "Authorization" = "Bearer $token"
}
$response = Invoke-RestMethod -Uri "https://micro.blog/micropub?q=config" -Headers $headers
$mediaEndpoint = $response."media-endpoint"
```

Upload the Image: Use the media endpoint to upload your image. Here’s how you can do it:
$imagePath = "path_to_your_image.jpg"
$form = @{
    file = Get-Item $imagePath
}
$uploadResponse = Invoke-RestMethod -Uri $mediaEndpoint -Method Post -Headers $headers -Form $form
$imageUrl = $uploadResponse.Location

Create a New Post: Now that you have the image URL, you can create a new post with the image:
$content = "Check out this photo!"
$postData = @{
    h = "entry"
    content = $content
    photo = $imageUrl
}
$postResponse = Invoke-RestMethod -Uri "https://micro.blog/micropub" -Method Post -Headers $headers -Body $postData

Replace "YOUR_APP_TOKEN" with your actual app token and "path_to_your_image.jpg" with the path to your image file.

This script will upload your image to Micro.blog and create a new post with the image included1.

If you have any questions or run into issues, feel free to ask!