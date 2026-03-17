# Configuración de ejemplo para S3 Vectors (PC-IAC-024, PC-IAC-026)
# Los valores de KMS se inyectan dinámicamente desde data sources en locals.tf

client      = "pragma"
project     = "aiplatform"
environment = "dev"
region      = "us-east-1"

common_tags = {
  Client      = "pragma"
  Project     = "aiplatform"
  Environment = "dev"
  Owner       = "platform-team"
  CostCenter  = "cc-ai-001"
}

vector_buckets_config = {
  "embeddings" = {
    encryption_type = "aws:kms"
    kms_key_arn     = "" # Se llenará automáticamente desde data source
    force_destroy   = true
    additional_tags = {
      UseCase = "document-embeddings"
    }

    indexes = {
      "documents" = {
        dimension       = 1536
        data_type       = "float32"
        distance_metric = "cosine"
        additional_tags = {
          Model = "titan-embed-v2"
        }
      }
      "images" = {
        dimension       = 1024
        data_type       = "float32"
        distance_metric = "euclidean"
        non_filterable_metadata_keys = ["raw_path"]
        additional_tags = {
          Model = "titan-embed-image-v1"
        }
      }
    }
  }

  "search" = {
    encryption_type = "AES256"
    force_destroy   = true
    additional_tags = {
      UseCase = "semantic-search"
    }

    indexes = {
      "products" = {
        dimension       = 768
        data_type       = "float32"
        distance_metric = "cosine"
      }
    }
  }
}
