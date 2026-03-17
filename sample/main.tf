###############################################################################
# Invocación del Módulo Padre - S3 Vectors (PC-IAC-013, PC-IAC-026)
###############################################################################

module "s3_vectors" {
  source = "../"

  providers = {
    aws.project = aws.principal
  }

  # Variables de Gobernanza (PC-IAC-003)
  client      = var.client
  project     = var.project
  environment = var.environment

  # Configuración transformada desde locals (PC-IAC-026)
  vector_buckets_config = local.vector_buckets_config_transformed
}
