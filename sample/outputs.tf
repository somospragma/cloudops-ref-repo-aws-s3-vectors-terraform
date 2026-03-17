output "vector_bucket_arns" {
  description = "ARNs de los vector buckets creados."
  value       = module.s3_vectors.vector_bucket_arns
}

output "vector_bucket_names" {
  description = "Nombres de los vector buckets creados."
  value       = module.s3_vectors.vector_bucket_names
}

output "vector_index_arns" {
  description = "ARNs de los vector indexes creados."
  value       = module.s3_vectors.vector_index_arns
}

output "vector_index_names" {
  description = "Nombres de los vector indexes creados."
  value       = module.s3_vectors.vector_index_names
}
