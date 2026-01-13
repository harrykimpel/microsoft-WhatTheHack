#!/bin/bash

# Include functions
source ./functions.sh
# Default values
LOCATION="East US 2"
DOCUMENT_INTELLIGENCE_LOCATION="East US"
OPENAI_LOCATION="East US 2"
RESOURCE_GROUP_NAME="newrelic-gameday-wth"
MODEL_NAME="gpt-5-mini"
MODEL_VERSION="2025-08-07"
# EMBEDDING_MODEL="text-embedding-ada-002"
# EMBEDDING_MODEL_VERSION="2"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --subscription-id) SUBSCRIPTION_ID="$2"; shift ;;
        --resource-group-name) RESOURCE_GROUP_NAME="$2"; shift ;;
        --location) LOCATION="$2"; shift ;;
        --tenant-id) TENANT_ID="$2"; shift ;;
        --use-service-principal) USE_SERVICE_PRINCIPAL=true ;;
        --service-principal-id) SERVICE_PRINCIPAL_ID="$2"; shift ;;
        --service-principal-password) SERVICE_PRINCIPAL_PASSWORD="$2"; shift ;;
        --openai-location) OPENAI_LOCATION="$2"; shift ;;
        --document-intelligence-location) DOCUMENT_INTELLIGENCE_LOCATION="$2"; shift ;;
        --skip-local-settings-file) SKIP_LOCAL_SETTINGS_FILE=true; shift ;;
        --silent-install) SILENT_INSTALL=true; shift ;;
        --model-name) MODEL_NAME="$2"; shift ;;
        --model-version) MODEL_VERSION="$2"; shift ;;
        # --embedding-model) EMBEDDING_MODEL="$2"; shift ;;
        # --embedding-model-version) EMBEDDING_MODEL_VERSION="$2"; shift ;;
        *) error_exit "Unknown parameter passed: $1" ;;
    esac
    shift
done

# Check if Bicep CLI is installed
# if ! command -v bicep &> /dev/null; then
#     error_exit "Bicep CLI not found. Install it using 'az bicep install'."
# fi

echo -e "\n\t\t\e[32mWHAT THE HACK - NEW RELIC GAMEDAY\e[0m"
echo -e "\tcreated with love by the New Relic DevRel Team!\n"

if [[ "$SILENT_INSTALL" == false ]]; then
    # Validate mandatory parameters, if required
    if [[ -z "$SUBSCRIPTION_ID" || -z "$RESOURCE_GROUP_NAME" ]]; then
        error_exit "Subscription ID and Resource Group Name are mandatory."
    fi
    authenticate_to_azure

    # Set the subscription
    az account set --subscription "$SUBSCRIPTION_ID" || error_exit "Failed to set subscription."

    # Display deployment parameters
    echo -e "The resources will be provisioned using the following parameters:"
    echo -e "\t          TenantId: \e[33m$TENANT_ID\e[0m"
    echo -e "\t    SubscriptionId: \e[33m$SUBSCRIPTION_ID\e[0m"
    echo -e "\t    Resource Group: \e[33m$RESOURCE_GROUP_NAME\e[0m"
    echo -e "\t            Region: \e[33m$LOCATION\e[0m"
    echo -e "\t   OpenAI Location: \e[33m$OPENAI_LOCATION\e[0m"
    echo -e "\t Azure DI Location: \e[33m$DOCUMENT_INTELLIGENCE_LOCATION\e[0m"
    echo -e "\t   Model Name: \e[33m$MODEL_NAME\e[0m"
    echo -e "\tModel Version: \e[33m$MODEL_VERSION\e[0m"
    echo -e "\tEmbedding Model: \e[33m$EMBEDDING_MODEL\e[0m"
    echo -e "\tEmbedding Model Version: \e[33m$EMBEDDING_MODEL_VERSION\e[0m"
    echo -e "\e[31mIf any parameter is incorrect, abort this script, correct, and try again.\e[0m"
    echo -e "It will take around \e[32m15 minutes\e[0m to deploy all resources. You can monitor the progress from the deployments page in the resource group in Azure Portal.\n"

    read -p "Press Y to proceed to deploy the resources using these parameters: " proceed
    if [[ "$proceed" != "Y" && "$proceed" != "y" ]]; then
        echo -e "\e[31mAborting deployment script.\e[0m"
        exit 1
    fi
fi
start=$(date +%s)

# Create resource group
echo -e "\n- Creating resource group: "
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" || error_exit "Failed to create resource group."

# Deploy resources
echo -e "\n- Deploying resources: "
result=$(az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --template-file ./main.bicep \
    --parameters openAILocation="$OPENAI_LOCATION" documentIntelligenceLocation="$DOCUMENT_INTELLIGENCE_LOCATION" modelName="$MODEL_NAME" modelVersion="$MODEL_VERSION") || error_exit "Azure deployment failed."

# Deployment completed
end=$(date +%s)
echo -e "\nThe deployment took: $((end - start)) seconds."
