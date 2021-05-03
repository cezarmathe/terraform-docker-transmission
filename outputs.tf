# terraform-docker-transmission - outputs.tf

output "config_volume_name" {
  description = <<-DESCRIPTION
  Name of the config volume.
  If 'create_config_volume' is set to 'false' this output will hold an empty string.
  DESCRIPTION
  value       = var.create_config_volume ? docker_volume.config[0].name : ""
}

output "watch_volume_name" {
  description = <<-DESCRIPTION
  Name of the watch volume.
  If 'create_watch_volume' is set to 'false' this output will hold an empty string.
  DESCRIPTION
  value       = var.create_watch_volume ? docker_volume.watch[0].name : ""
}

output "downloads_volume_name" {
  description = <<-DESCRIPTION
  Name of the downloads volume.
  If 'create_downloads_volume' is set to 'false' this output will hold an empty string.
  DESCRIPTION
  value       = var.create_downloads_volume ? docker_volume.downloads[0].name : ""
}

output "this_name" {
  description = "Name of the container."
  value       = docker_container.this.name
}

output "this_network_data" {
  description = <<-DESCRIPTION
  Network configuration of the container. This exports the 'network_data' attribute of the docker
  container, check the docker provider (kreuzwerker/docker) for more info.
  DESCRIPTION
  value       = docker_container.this.network_data
}

output "this_uuid" {
  description = "The random uuid used for naming the resources created by this module."
  value       = random_uuid.this.result
}
