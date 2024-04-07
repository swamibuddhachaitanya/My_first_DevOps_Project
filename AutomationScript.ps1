##make additions in the server code then only run this script.
##before running this initialise the version variable in the powershell cli to $curr_version= "0.0"

# Define your variables here
$sp_client_id = "YOUR_SERVICE_PRINCIPAL_CLIENT_ID"
$sp_client_pswd = "YOUR_SERVICE_PRINCIPAL_CLIENT_SECRET"
$sp_tenant_id = "YOUR_SERVICE_PRINCIPAL_TENANT_ID"
$resource_group = "YOUR_RESOURCE_GROUP_NAME"
$acr_name = "YOUR_ACR_NAME"
$docker_image_name = "YOUR_DOCKER_IMAGE_NAME"
$dockerfilePath = "PATH_TO_YOUR_DOCKERFILE"

# Login to Azure using service principal
az login --service-principal -u $sp_client_id -p $sp_client_pswd --tenant $sp_tenant_id

# Creating Azure Container Registry (ACR)
az acr create --resource-group $resource_group --name $acr_name --sku Standard

# Obtaining access token for ACR login
$acr_repo_token = (az acr login --name $acr_name --expose-token --only-show-errors | ConvertFrom-Json).accessToken

#docker login using the above token
docker login "$acr_name.azurecr.io" --username 00000000-0000-0000-0000-000000000000 --password "$acr_repo_token"

#obtain the all the versions tags present in the acr
$imageTags = az acr repository show-tags --name $acr_name --repository $docker_image_name --output json | ConvertFrom-Json

# Check if any tags are returned
if ($imageTags) {
    # Sort the tags to find the one with the greatest version
    $latestTag = $imageTags | Sort-Object -Descending | Select-Object -First 1
    
    # Extract the version number from the tag and Store the version number in the $curr_version variable
    $curr_version = $latestTag -replace "${docker_image_name}:", ""
} else {
    # If no tags are found, set $curr_version to "0.0"
    $curr_version = "0.0"
}

# build the image with the new version
docker build -t "${docker_image_name}:latest" -f "${dockerfilePath}".
docker tag "${docker_image_name}:latest" "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"

# Push the Docker image to ACR
docker push "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"

# Pull the Docker image with the curr_version tag
docker pull "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"

# Define the name of the previous version
$image_to_delete = "${acr_name}.azurecr.io/${docker_image_name}:${prev_version}"

# Find the image ID based on the image name
$image_id = docker images --format "{{.ID}}" $image_to_delete

# Check if the image ID is not empty
if ($image_id) {
    # Find the container ID based on the image ID
    $container_id = docker ps -q --filter ancestor=$image_id

    # Check if a container is running with the specified image
    if ($container_id) {
        # Stop the container
        docker stop $container_id
        docker image rmi -f $image_id
        # Write-Host "Container with image '$image_to_delete' stopped (Container ID: $container_id)"
    }
}

# run the pulled image on the local machine
docker run -d -p 3000:3000 "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"
