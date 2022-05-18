# Deploy to AWS Using Terraform

## Instructions

1. From the repository root, run `dotnet build WebApplication1`
2. From the `infra` directory, run `terraform init`
3. From the `infra` directory, run `terraform apply -auto-approve`
4. From the `infra` directory, run `curl "$(terraform output -raw http_api_base_url)WeatherForecast"`
5. From the `infra` directory, run `terraform destroy -auto-approve`
