# DEMO 3 - ACI File share
# -----------------------------------------------------------------------------
# References:
#   Mount an Azure file share in Azure Container Instances
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files

# Azure file share
# Change these parameters as needed
resource_group=Microsoft-Reactor
storage_account_name=acivolumes
location=westus
file_share_name=aci-fileshare
aci_name=aci-sql-dev02;

# Getting Azure storage key
storage_key=$(az storage account keys list --resource-group $resource_group \
                --account-name $storage_account_name --query "[0].value" --output tsv);

# Getting Azure storage connection string
conn_string=$(az storage account show-connection-string \
                --resource-group $resource_group --name $storage_account_name);

# Create the storage account with the parameters
az storage account create \
    --resource-group $resource_group \
    --name $storage_account_name \
    --location $location \
    --sku Standard_LRS

# Create the file share
az storage share create \
    --name $file_share_name \
    --account-name $storage_account_name \
    --account-key $storage_key

# Create ACI with file share volume
az container create \
    --resource-group $resource_group \
    --name $aci_name \
    --image mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04 \
    --environment-variables ACCEPT_EULA=Y SA_PASSWORD=_SqLr0ck5_ \
    --dns-name-label $aci_name \
    --cpu 4  --memory 4 \
    --port 1433 \
    --azure-file-volume-account-name $storage_account_name \
    --azure-file-volume-account-key $storage_key \
    --azure-file-volume-share-name $file_share_name \
    --azure-file-volume-mount-path /SQLFiles

# Check ACI status
az container show \
    --resource-group $resource_group \
    --name $aci_name -o table