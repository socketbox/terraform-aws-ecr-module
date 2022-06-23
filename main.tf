resource "aws_ecr_repository" "repo" {
  name                 = local.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "repo_lifecycle_policy" {
  count      = var.images_to_retain == null ? 0 : 1
  repository = local.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.images_to_retain} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.images_to_retain}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
  depends_on = [
    aws_ecr_repository.repo,
  ]
}
