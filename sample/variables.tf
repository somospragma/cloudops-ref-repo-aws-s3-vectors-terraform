###############################################################################
# Variables de Gobernanza (PC-IAC-002)
###############################################################################

variable "client" {
  description = "Nombre del cliente o unidad de negocio."
  type        = string
  default     = "pragma"
}

variable "project" {
  description = "Nombre del proyecto."
  type        = string
  default     = "aiplatform"
}

variable "environment" {
  description = "Entorno de despliegue."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Región de AWS para el despliegue."
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Etiquetas transversales de gobernanza aplicadas a todos los recursos."
  type        = map(string)
  default = {
    Client      = "pragma"
    Project     = "aiplatform"
    Environment = "dev"
    Owner       = "platform-team"
    CostCenter  = "cc-ai-001"
  }
}

###############################################################################
# Variable de Configuración - Vector Buckets (PC-IAC-024)
###############################################################################

variable "vector_buckets_config" {
  description = "Mapa de configuración para los vector buckets de S3 Vectors."
  type = map(object({
    encryption_type   = optional(string, "AES256")
    kms_key_arn       = optional(string, "")
    force_destroy     = optional(bool, false)
    additional_tags   = optional(map(string), {})
    bucket_policy     = optional(string, "")

    indexes = optional(map(object({
      dimension                    = number
      data_type                    = optional(string, "float32")
      distance_metric              = optional(string, "cosine")
      encryption_type              = optional(string, "")
      kms_key_arn                  = optional(string, "")
      non_filterable_metadata_keys = optional(list(string), [])
      additional_tags              = optional(map(string), {})
    })), {})
  }))
  default = {}
}
