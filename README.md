# Módulo de Referencia - Amazon S3 Vectors

Módulo de Terraform para la gestión de **Amazon S3 Vectors**, el primer almacenamiento de objetos en la nube con soporte nativo para almacenar y consultar vectores. Este módulo crea vector buckets, vector indexes y bucket policies de forma estandarizada.

## Descripción del Recurso

Amazon S3 Vectors ofrece almacenamiento optimizado para datos vectoriales con latencia sub-segundo para consultas infrecuentes y hasta 100ms para consultas frecuentes. Soporta hasta 2 mil millones de vectores por índice y 10,000 índices por vector bucket.

### Recursos Gestionados

| Recurso | Descripción |
|---------|-------------|
| `aws_s3vectors_vector_bucket` | Vector bucket para almacenamiento de vectores |
| `aws_s3vectors_index` | Índice vectorial dentro de un vector bucket |
| `aws_s3vectors_vector_bucket_policy` | Política de acceso del vector bucket |

## Uso

```hcl
module "s3_vectors" {
  source  = "git::https://repo/s3-vectors-module.git?ref=v1.0.0"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  vector_buckets_config = local.vector_buckets_config_transformed
}
```

## Inputs

| Variable | Tipo | Requerida | Default | Descripción |
|----------|------|-----------|---------|-------------|
| `client` | `string` | Sí | - | Nombre del cliente (máx. 10 caracteres) |
| `project` | `string` | Sí | - | Nombre del proyecto (máx. 15 caracteres) |
| `environment` | `string` | Sí | - | Entorno: `dev`, `qa`, `pdn` |
| `vector_buckets_config` | `map(object)` | No | `{}` | Mapa de configuración de vector buckets |

### Estructura de `vector_buckets_config`

```hcl
vector_buckets_config = {
  "nombre-bucket" = {
    encryption_type   = "AES256"       # "AES256" o "aws:kms"
    kms_key_arn       = ""             # ARN de KMS (requerido si encryption_type = "aws:kms")
    force_destroy     = false          # Eliminar índices y vectores al destruir
    additional_tags   = {}             # Tags adicionales
    bucket_policy     = ""             # Política JSON del bucket (opcional)

    indexes = {
      "nombre-index" = {
        dimension                    = 1536        # Dimensiones del vector (requerido)
        data_type                    = "float32"   # Tipo de dato
        distance_metric              = "cosine"    # "cosine" o "euclidean"
        encryption_type              = ""          # Hereda del bucket si vacío
        kms_key_arn                  = ""          # Hereda del bucket si vacío
        non_filterable_metadata_keys = []          # Claves de metadata no filtrables
        additional_tags              = {}          # Tags adicionales
      }
    }
  }
}
```

## Outputs

| Output | Tipo | Descripción |
|--------|------|-------------|
| `vector_bucket_arns` | `map(string)` | ARNs de los vector buckets, indexado por clave |
| `vector_bucket_names` | `map(string)` | Nombres de los vector buckets, indexado por clave |
| `vector_bucket_creation_times` | `map(string)` | Fechas de creación de los vector buckets |
| `vector_index_arns` | `map(string)` | ARNs de los vector indexes, indexado por `bucket_key:index_key` |
| `vector_index_names` | `map(string)` | Nombres de los vector indexes, indexado por `bucket_key:index_key` |

## Requisitos

| Requisito | Versión |
|-----------|---------|
| Terraform | >= 1.5.0 |
| AWS Provider | >= 5.80.0 |

## Nomenclatura

Los recursos siguen el patrón de nomenclatura estándar PC-IAC-003:

- Vector Buckets: `{client}-{project}-{environment}-s3v-{key}`
- Vector Indexes: `{client}-{project}-{environment}-s3vidx-{key}`

## Cumplimiento PC-IAC

| Regla | Descripción | Implementación |
|-------|-------------|----------------|
| PC-IAC-001 | Estructura de Módulo | 10 archivos raíz + 8 archivos en sample/ |
| PC-IAC-002 | Variables | `map(object)` con validaciones, `optional()` para defaults |
| PC-IAC-003 | Nomenclatura | Prefijo `{client}-{project}-{environment}` construido en `locals.tf` |
| PC-IAC-005 | Providers | Alias consumidor `aws.project` con `configuration_aliases` |
| PC-IAC-007 | Outputs | ARNs e IDs granulares con `description` obligatoria |
| PC-IAC-010 | For_Each | `for_each` sobre `map(object)` para estabilidad del estado |
| PC-IAC-014 | Bloques Dinámicos | `dynamic` para `encryption_configuration` y `metadata_configuration` |
| PC-IAC-020 | Seguridad | Cifrado en reposo por defecto (AES256), soporte SSE-KMS |
| PC-IAC-023 | Responsabilidad Única | Solo recursos intrínsecos a S3 Vectors (bucket, index, policy) |
| PC-IAC-026 | Patrón sample/ | Flujo `tfvars → data → locals → main` con inyección dinámica |

## Decisiones de Diseño

1. **Cifrado por defecto**: Todos los vector buckets se crean con cifrado AES256 por defecto. Se puede escalar a SSE-KMS proporcionando el ARN de la clave.

2. **Herencia de cifrado en índices**: Los índices heredan la configuración de cifrado del bucket padre si no se especifica una propia, reduciendo la duplicación de configuración.

3. **Aplanamiento de índices**: Se usa `flatten()` en `locals.tf` para convertir la estructura anidada de índices en un mapa plano compatible con `for_each`, garantizando estabilidad del estado.

4. **Bucket policy opcional**: La política del bucket solo se crea si se proporciona un JSON de política, evitando recursos vacíos.

5. **Block Public Access**: Amazon S3 Vectors tiene Block Public Access habilitado permanentemente y no puede deshabilitarse, por lo que no se requiere configuración adicional de hardenizado en este aspecto.

6. **Namespace separado**: S3 Vectors usa el namespace `s3vectors` (diferente a `s3`), lo que permite diseñar políticas IAM específicas para el servicio.

---

**Última actualización:** 17-03-2026

**Versión del documento:** 1.0.0

**Mantenido por:** Pragma - CloudOps Team

---

> Este módulo ha sido desarrollado siguiendo los estándares de Pragma CloudOps, garantizando una implementación segura, escalable y optimizada que cumple con todas las políticas de la organización. Pragma CloudOps recomienda revisar este código con su equipo de infraestructura antes de implementarlo en producción.