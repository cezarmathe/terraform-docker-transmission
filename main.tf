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

resource "random_uuid" "this" {}

data "docker_registry_image" "this" {
  name = "ghcr.io/linuxserver/transmission:${var.image_version}"
}

resource "docker_image" "this" {
  name          = data.docker_registry_image.this.name
  pull_triggers = [data.docker_registry_image.this.sha256_digest]
}

resource "docker_volume" "config" {
  count = var.create_config_volume ? 1 : 0

  name        = local.config_volume_name
  driver      = var.config_volume_driver
  driver_opts = var.config_volume_driver_opts
}

resource "docker_volume" "watch" {
  count = var.create_watch_volume ? 1 : 0

  name        = local.watch_volume_name
  driver      = var.watch_volume_driver
  driver_opts = var.watch_volume_driver_opts
}

resource "docker_volume" "downloads" {
  count = var.create_downloads_volume ? 1 : 0

  name        = local.downloads_volume_name
  driver      = var.downloads_volume_driver
  driver_opts = var.downloads_volume_driver_opts
}

resource "docker_container" "this" {
  name  = local.container_name
  image = docker_image.this.latest

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

  # user-defined additional downloads volumes
  dynamic "volumes" {
    for_each = local.processed_user_volumes
    iterator = volume
    content {
      volume_name    = volume.value.volume_name
      container_path = "/downloads/${volume.value.dir_name}"
    }
  }

  must_run = true
  restart  = var.restart
  start    = var.start
}

locals {
  config_volume_name = var.create_config_volume ? (
    var.config_volume_name != "" ? var.config_volume_name : (
      "transmission_config_${random_uuid.this.result}"
    )
  ) : ""

  watch_volume_name = var.create_watch_volume ? (
    var.watch_volume_name != "" ? var.watch_volume_name : (
      "transmission_watch_${random_uuid.this.result}"
    )
  ) : ""

  downloads_volume_name = var.create_downloads_volume ? (
    var.downloads_volume_name != "" ? var.downloads_volume_name : (
      "transmission_downloads_${random_uuid.this.result}"
    )
  ) : ""

  container_name = var.container_name != "" ? var.container_name : (
    "transmission_${random_uuid.this.result}"
  )

  processed_user_volumes = [for user_volume in var.user_volumes : {
    volume_name = user_volume.volume_name
    dir_name    = user_volume.dir_name != "" ? user_volume.dir_name : user_volume.volume_name
  }]
}
