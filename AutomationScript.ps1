## Make additions in the server code then only run this script.
## Before running this, initialize the version variable in the PowerShell CLI to $curr_version = "0.0"

# Define variables
$resource_group = "Tutorial"
$acr_name = "acrforautomation"
$docker_image_name = "basic-node-app"
$dockerfilePath = "C:\Path\To\Dockerfile"
$prev_version = [version]$curr_version
$prev_version = $prev_version.ToString()

# Increment the version number
$curr_version = [version]$curr_version
$curr_version = [version]::new($curr_version.Major, $curr_version.Minor + 1)
$curr_version = $curr_version.ToString()

# Build the image with the new version
docker build -t "${docker_image_name}:latest" -f "${dockerfilePath}" .
docker tag "${docker_image_name}:latest" "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"

# Login to Azure using service principal
az login --service-principal -u $sp_client_id -p $sp_client_pswd --tenant $sp_tenant_id

# Creating Azure Container Registry (ACR)
az acr create --resource-group $resource_group --name $acr_name --sku Standard

# Obtaining access token for ACR login
$acr_repo_token = (az acr login --name $acr_name --expose-token --only-show-errors | ConvertFrom-Json).accessToken

# Docker login using the above token
docker login "$acr_name.azurecr.io" --username 00000000-0000-0000-0000-000000000000 --password "$acr_repo_token"

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

# Run the pulled image on the local machine
docker run -d -p 3000:3000 "${acr_name}.azurecr.io/${docker_image_name}:${curr_version}"
