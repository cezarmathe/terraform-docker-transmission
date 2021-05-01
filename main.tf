# terraform-docker-transmission - main.tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.14"
}

data "docker_registry_image" "this" {
  name = "ghcr.io/linuxserver/transmission:${var.image_version}"
}

resource "docker_image" "this" {
  name          = data.docker_registry_image.this.name
  pull_triggers = [data.docker_registry_image.this.sha256_digest]
}

resource "random_uuid" "config_volume" {
  count = var.create_config_volume ? 1 : 0
}

resource "docker_volume" "config" {
  count = var.create_config_volume ? 1 : 0

  name        = "transmission_config_${random_uuid.config_volume.result[0]}"
  driver      = var.config_volume_driver
  driver_opts = var.config_volume_driver_opts
}

resource "random_uuid" "watch_volume" {
  count = var.create_watch_volume ? 1 : 0
}

resource "docker_volume" "watch" {
  count = var.create_watch_volume ? 1 : 0

  name        = "transmission_watch_${random_uuid.watch_volume.result[0]}"
  driver      = var.watch_volume_driver
  driver_opts = var.watch_volume_driver_opts
}

resource "random_uuid" "downloads_volume" {
  count = var.create_downloads_volume ? 1 : 0
}

resource "docker_volume" "downloads" {
  count = var.create_downloads_volume ? 1 : 0

  name        = "transmission_downloads_${random_uuid.downloads_volume.result[0]}"
  driver      = var.downloads_volume_driver
  driver_opts = var.downloads_volume_driver_opts
}

resource "random_uuid" "container_name" {
  count = var.create_downloads_volume ? 1 : 0
}

resource "docker_container" "this" {
  name  = var.container_name != "" ? var.container_name : "transmission_${random_uuid.container_name.result}"
  image = docker_image.transmission.latest

  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "TRANSMISSION_WEB_HOME=/${var.web_interface}/",
    "USER=${var.username}",
    "PASS=${var.password}",
  ]

  ports {
    internal = 51413
    external = 51413
    protocol = "tcp"
  }

  ports {
    internal = 51413
    external = 51413
    protocol = "udp"
  }

  # config volume
  dynamic "volumes" {
    for_each = docker_volume.config
    iterator = volume
    content {
      volume_name    = volume.value.name
      container_path = "/config"
    }
  }

  # watch volume
  dynamic "volumes" {
    for_each = docker_volume.watch
    iterator = volume
    content {
      volume_name    = volume.value.name
      container_path = "/watch"
    }
  }

  # default downloads volume
  dynamic "volumes" {
    for_each = docker_volume.downloads
    iterator = volume
    content {
      volume_name    = volume.value.name
      container_path = "/downloads/default"
    }
  }

  must_run = true
  restart  = var.restart
  start    = var.start
}
