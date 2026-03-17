locals {
  # Prefijo de gobernanza para el ejemplo (PC-IAC-025)
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # Transformar configuración inyectando KMS key ARN dinámico (PC-IAC-009, PC-IAC-026)
  vector_buckets_config_transformed = {
    for key, config in var.vector_buckets_config : key => merge(config, {
      kms_key_arn = config.encryption_type == "aws:kms" && length(config.kms_key_arn) == 0 ? data.aws_kms_key.s3vectors.arn : config.kms_key_arn
    })
  }
}
