# Introduction 

Simple Azure demo that demonstrates interaction between the following services according to recommended Azure best practises:

* ASP.Net Core App 
* App Service 
* Key Vault Service
* App Configuration Service

# Run Demo 

## Create infrastructure 
1. Create local config file for terraform `local.tfvars.json` with required input (accoring to `variables.tf`)
1. Login to Azure: `az login`
1. Select desired subscription: `az account set --subscription ID`
1. Initialize Terraform: `terraform init`
1. Apply Terraform `terraform apply -var-file local.tfvars.json`

## Set configuration in App configuration service 
* Add the following configurations to the app configuration service via portal: `TestApp:Settings:BackgroundColor`=> `e.g. Yellow`
* Add a feature toggle with the Key `Beta`

## Deploy app
* Build & Publish `/app/app.csproj` to newly created app service 

## Play around 
* Change `BackgroundColor` configuration => check behaviour in app 
* Toggle feature `Beta` => check behaviour in app 

# Resources 
* https://docs.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices
* https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureAppConfiguration/
* https://www.nuget.org/packages/Microsoft.FeatureManagement/ 
* https://12factor.net/config 