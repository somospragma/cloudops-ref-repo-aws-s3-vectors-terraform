# Ejemplo de Uso del Módulo S3 Vectors

Este directorio contiene un ejemplo funcional que demuestra cómo consumir el módulo de referencia de Amazon S3 Vectors.

## Prerrequisitos

- Terraform >= 1.5.0
- AWS Provider >= 5.80.0
- Una KMS Key con alias `{client}-{project}-{environment}-kms-s3vectors` (si se usa cifrado SSE-KMS)

## Ejecución

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Patrón de Transformación (PC-IAC-026)

Este ejemplo sigue el flujo obligatorio:

```
terraform.tfvars → variables.tf → data.tf → locals.tf → main.tf → ../
```

- `terraform.tfvars`: Configuración declarativa sin IDs hardcodeados.
- `data.tf`: Data sources para obtener KMS Key ARN dinámicamente.
- `locals.tf`: Transformación e inyección de IDs dinámicos.
- `main.tf`: Invocación limpia del módulo padre con `local.*`.
