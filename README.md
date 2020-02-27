# Introduction 

Simple Azure demo that demonstrates interaction between the following services according to recommended Azure best practises:

* ASP.Net Core App 
* App Service 
* Key Vault Service
* App Configuration Service

# Run Demo 

## Create infrastructure 
1. Change the Azure backend part (line 3-5) in `main.tf` to an existing storage account in your subscription (required for storing terraform state)
1. Login to Azure: `az login`
1. Select subscription of terraform state: `az account set --subscription XXX`
1. Initialize Terraform: `terraform init`
1. Apply Terraform with the subscription ID & tenant ID where you want to deploy the demo `terraform apply -var 'subscription_id=XXX' -var 'tenant_id=XXX'`

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