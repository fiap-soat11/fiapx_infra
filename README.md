# fiapx_infra
Infraestrutura destinada ao projeto do Hackaton


## Passo a Passo

1. Atualize as variáveis de organização (https://github.com/organizations/fiap-soat11/settings/variables/actions): AWS_ACCESS_KEY_ID, AWS_ACCOUNT_ID e AWS_REGION.

2. Atualize os segredos da organização (https://github.com/organizations/fiap-soat11/settings/secrets/actions): AWS_SECRET_ACCESS_KEY e AWS_SESSION_TOKEN.

3. Execute a action para criar o bucket S3 para o tfstate (https://github.com/fiap-soat11/fiapx_infra/actions/workflows/bucket-s3.yml)

4. Execute a action para criar toda a infraestrutura (https://github.com/fiap-soat11/fiapx_infra/actions/workflows/terraform.yml): Database, S3, SQS, EKS e API Gateway