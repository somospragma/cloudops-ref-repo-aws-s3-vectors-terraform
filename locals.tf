locals {
  # Prefijo de gobernanza (PC-IAC-003, PC-IAC-012)
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # Construcción de nombres para vector buckets (PC-IAC-003)
  vector_bucket_names = {
    for key, config in var.vector_buckets_config :
    key => "${local.governance_prefix}-s3v-${key}"
  }

  # Aplanamiento de índices para for_each (PC-IAC-012)
  indexes_flat = flatten([
    for bucket_key, bucket_config in var.vector_buckets_config : [
      for index_key, index_config in bucket_config.indexes : {
        bucket_key                   = bucket_key
        index_key                    = index_key
        composite_key                = "${bucket_key}:${index_key}"
        vector_bucket_name           = local.vector_bucket_names[bucket_key]
        index_name                   = "${local.governance_prefix}-s3vidx-${index_key}"
        dimension                    = index_config.dimension
        data_type                    = index_config.data_type
        distance_metric              = index_config.distance_metric
        encryption_type              = length(index_config.encryption_type) > 0 ? index_config.encryption_type : bucket_config.encryption_type
        kms_key_arn                  = length(index_config.kms_key_arn) > 0 ? index_config.kms_key_arn : bucket_config.kms_key_arn
        non_filterable_metadata_keys = index_config.non_filterable_metadata_keys
        additional_tags              = index_config.additional_tags
      }
    ]
  ])

  # Mapa de índices para for_each (PC-IAC-010)
  indexes_map = {
    for idx in local.indexes_flat : idx.composite_key => idx
  }
}
