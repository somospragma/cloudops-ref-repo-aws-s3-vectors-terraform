###############################################################################
# Amazon S3 Vectors - Vector Buckets (PC-IAC-010, PC-IAC-020, PC-IAC-023)
###############################################################################

resource "aws_s3vectors_vector_bucket" "this" {
  for_each = var.vector_buckets_config
  provider = aws.project

  vector_bucket_name = local.vector_bucket_names[each.key]
  force_destroy      = each.value.force_destroy

  encryption_configuration {
    sse_type    = each.value.encryption_type
    kms_key_arn = each.value.encryption_type == "aws:kms" ? each.value.kms_key_arn : null
  }

  tags = merge(
    { Name = local.vector_bucket_names[each.key] },
    each.value.additional_tags
  )
}

###############################################################################
# Amazon S3 Vectors - Vector Indexes (PC-IAC-010, PC-IAC-014)
###############################################################################

resource "aws_s3vectors_index" "this" {
  for_each = local.indexes_map
  provider = aws.project

  index_name         = each.value.index_name
  vector_bucket_name = aws_s3vectors_vector_bucket.this[each.value.bucket_key].vector_bucket_name

  data_type       = each.value.data_type
  dimension       = each.value.dimension
  distance_metric = each.value.distance_metric

  dynamic "encryption_configuration" {
    for_each = each.value.encryption_type == "aws:kms" ? [1] : []
    content {
      sse_type    = each.value.encryption_type
      kms_key_arn = each.value.kms_key_arn
    }
  }

  dynamic "metadata_configuration" {
    for_each = length(each.value.non_filterable_metadata_keys) > 0 ? [1] : []
    content {
      non_filterable_metadata_keys = each.value.non_filterable_metadata_keys
    }
  }

  tags = merge(
    { Name = each.value.index_name },
    each.value.additional_tags
  )
}

###############################################################################
# Amazon S3 Vectors - Bucket Policies (PC-IAC-010, PC-IAC-020)
###############################################################################

resource "aws_s3vectors_vector_bucket_policy" "this" {
  for_each = {
    for key, config in var.vector_buckets_config :
    key => config if length(config.bucket_policy) > 0
  }
  provider = aws.project

  vector_bucket_arn = aws_s3vectors_vector_bucket.this[each.key].vector_bucket_arn
  policy            = each.value.bucket_policy
}
