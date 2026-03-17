# Data sources para obtener IDs dinámicos en el ejemplo (PC-IAC-011, PC-IAC-026)

data "aws_kms_key" "s3vectors" {
  provider = aws.principal
  key_id   = "alias/${var.client}-${var.project}-${var.environment}-kms-s3vectors"
}
