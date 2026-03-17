# Changelog

Todos los cambios notables de este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/),
y este proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

## [1.0.0] - 2026-03-17

### Added

- Recurso `aws_s3vectors_vector_bucket` con soporte para cifrado SSE-S3 y SSE-KMS.
- Recurso `aws_s3vectors_index` con soporte para múltiples índices por bucket.
- Recurso `aws_s3vectors_vector_bucket_policy` opcional por bucket.
- Soporte para `for_each` mediante `map(object)` para múltiples vector buckets.
- Nomenclatura estándar PC-IAC-003 con prefijo de gobernanza.
- Hardenizado de seguridad: cifrado en reposo por defecto (PC-IAC-020).
- Ejemplo funcional en `sample/` con patrón de transformación PC-IAC-026.
