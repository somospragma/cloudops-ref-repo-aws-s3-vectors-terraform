###############################################################################
# Outputs - Vector Buckets (PC-IAC-007, PC-IAC-014)
###############################################################################

output "vector_bucket_arns" {
  description = "Mapa de ARNs de los vector buckets creados, indexado por la clave del mapa de configuración."
  value = {
    for key, bucket in aws_s3vectors_vector_bucket.this :
    key => bucket.vector_bucket_arn
  }
}

output "vector_bucket_names" {
  description = "Mapa de nombres de los vector buckets creados, indexado por la clave del mapa de configuración."
  value = {
    for key, bucket in aws_s3vectors_vector_bucket.this :
    key => bucket.vector_bucket_name
  }
}

output "vector_bucket_creation_times" {
  description = "Mapa de fechas de creación de los vector buckets, indexado por la clave del mapa de configuración."
  value = {
    for key, bucket in aws_s3vectors_vector_bucket.this :
    key => bucket.creation_time
  }
}

###############################################################################
# Outputs - Vector Indexes (PC-IAC-007, PC-IAC-014)
###############################################################################

output "vector_index_arns" {
  description = "Mapa de ARNs de los vector indexes creados, indexado por la clave compuesta 'bucket_key:index_key'."
  value = {
    for key, index in aws_s3vectors_index.this :
    key => index.index_arn
  }
}

output "vector_index_names" {
  description = "Mapa de nombres de los vector indexes creados, indexado por la clave compuesta 'bucket_key:index_key'."
  value = {
    for key, index in aws_s3vectors_index.this :
    key => index.index_name
  }
}
