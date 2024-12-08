resource "aws_ecr_repository" "IDS-repo" {
  name = var.ecr_repo_name
}
resource "null_resource" "write_ecr_uri" {
  provisioner "local-exec" {
    command = "echo '${aws_ecr_repository.IDS-repo.repository_url}' > ecr_repo_uri.txt"
  }

  depends_on = [aws_ecr_repository.IDS-repo]
}