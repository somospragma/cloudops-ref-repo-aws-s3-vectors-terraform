###############################################################################
# Variables de Gobernanza (PC-IAC-002, PC-IAC-003)
###############################################################################

variable "client" {
  description = "Nombre del cliente o unidad de negocio. Se usa para la construcción de nomenclatura estándar."
  type        = string

  validation {
    condition     = length(var.client) > 0 && length(var.client) <= 10
    error_message = "La variable 'client' no puede estar vacía y debe tener máximo 10 caracteres."
  }
}

variable "project" {
  description = "Nombre del proyecto. Se usa para la construcción de nomenclatura estándar."
  type        = string

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 15
    error_message = "La variable 'project' no puede estar vacía y debe tener máximo 15 caracteres."
  }
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn)."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn"], var.environment)
    error_message = "La variable 'environment' debe ser uno de: dev, qa, pdn."
  }
}

###############################################################################
# Variable de Configuración Principal - Vector Buckets (PC-IAC-002, PC-IAC-009)
###############################################################################

variable "vector_buckets_config" {
  description = "Mapa de configuración para los vector buckets de S3 Vectors. Cada clave representa un vector bucket único."
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

  validation {
    condition = alltrue([
      for key, config in var.vector_buckets_config :
      contains(["AES256", "aws:kms"], config.encryption_type)
    ])
    error_message = "El campo 'encryption_type' debe ser 'AES256' o 'aws:kms'."
  }

  validation {
    condition = alltrue([
      for key, config in var.vector_buckets_config :
      config.encryption_type != "aws:kms" || length(config.kms_key_arn) > 0
    ])
    error_message = "Cuando 'encryption_type' es 'aws:kms', se debe proporcionar 'kms_key_arn'."
  }

  validation {
    condition = alltrue([
      for key, config in var.vector_buckets_config :
      alltrue([
        for idx_key, idx in config.indexes :
        idx.dimension > 0
      ])
    ])
    error_message = "El campo 'dimension' de cada índice debe ser mayor a 0."
  }

  validation {
    condition = alltrue([
      for key, config in var.vector_buckets_config :
      alltrue([
        for idx_key, idx in config.indexes :
        contains(["float32"], idx.data_type)
      ])
    ])
    error_message = "El campo 'data_type' de cada índice debe ser 'float32'."
  }

  validation {
    condition = alltrue([
      for key, config in var.vector_buckets_config :
      alltrue([
        for idx_key, idx in config.indexes :
        contains(["cosine", "euclidean"], idx.distance_metric)
      ])
    ])
    error_message = "El campo 'distance_metric' de cada índice debe ser 'cosine' o 'euclidean'."
  }
}
