# DEMO 3 - Multi container deployment
#
#   1- Create resource group
#   2- Inspect YAML deployment
#   3- Deploy container group
#   4- Check ACI group status
#   5- Check containers logs
# -----------------------------------------------------------------------------
# References:
#   Mount an Azure file share in Azure Container Instances
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files
#
#   Azure subnet creation
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-vnet#deployment-scenarios
#   
#   Multi container deployment in ACI
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-multi-container-group
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-reference-yaml
#
#   YAML properties for ACI
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-reference-yaml

# 0- Env variables | demo path
resource_group=Microsoft-Reactor
location=westus
aci_group_name=AG-RedScale;
aci_container_1=rs-master-01;
aci_container_2=rs-master-02;
cd ~/Documents/$resource_group/Demo_03;
sa_password="_SqLr0ck5_"

# 1- Inspect YAML deployment
code ACI-ContainerGroup.yaml

# 2- Deploy container group
az container create --resource-group $resource_group --file ACI-ContainerGroup.yaml

# 3- Check ACI group status
az container show --resource-group $resource_group --name $aci_group_name --output table

# 4- Check containers logs
az container logs --resource-group $resource_group --name $aci_group_name --container-name $aci_container_1
az container logs --resource-group $resource_group --name $aci_group_name --container-name $aci_container_2

# 5- Connect to ACI containers
sqlcmd -S 52.190.216.243,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
