# terraform-docker-transmission - variables.tf


variable "timezone" {
  type        = string
  description = "Timezone configuration for the container."
  default     = "Europe/London"
}

variable "uid" {
  type        = number
  description = "Uid for the transmission process."
  default     = 1000
}

variable "gid" {
  type        = number
  description = "Gid for the transmission process."
  default     = 1000
}

variable "web_interface" {
  type        = string
  description = <<-DESCRIPTION
  Transmission web interface. Choose one of: "combustion-release", "transmission-web-control" or
  "kettu".
  DESCRIPTION
  default     = "combustion-release"
}

variable "image_version" {
  type        = string
  description = <<-DESCRIPTION
  Container image version. This module uses 'linuxserver/transmission'.
  DESCRIPTION
  default     = "latest"
}

variable "username" {
  type        = string
  description = "Transmission webui username."
  default     = ""
  sensitive   = true
}

variable "password" {
  type        = string
  description = "Transmission webui password."
  default     = ""
  sensitive   = true
}

variable "start" {
  type        = bool
  description = "Whether to start the container or just create it."
  default     = true
}

variable "restart" {
  type        = string
  description = <<-DESCRIPTION
  The restart policy of the container. Must be one of: "no", "on-failure", "always",
  "unless-stopped".
  DESCRIPTION
  default     = "unless-stopped"
}

variable "user_volumes" {
  type        = list(object({
    volume_name = string
    dir_name    = string
  }))
  description = <<-DESCRIPTION
  A list of additional user volumes to attach inside the downloads directory of the container. Each
  volume will be attached to '/downloads/{dir_name}' if '{dir_name}' is not empty, or
  '/downloads/{volume_name}' otherwise.
  DESCRIPTION
  default     = []
}

variable "create_config_volume" {
  type        = bool
  description = "Create a volume for the '/config' directory."
  default     = true
}

variable "config_volume_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the config volume. If empty, a name will be automatically generated like this:
  'transmission_config_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "config_volume_driver" {
  type        = string
  description = "Storage driver for the config volume."
  default     = "local"
}

variable "config_volume_driver_opts" {
  type        = map(any)
  description = "Storage driver options for the config volume."
  default     = {}
}

variable "create_watch_volume" {
  type        = bool
  description = "Create a volume for the '/watch' directory."
  default     = true
}

variable "watch_volume_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the watch volume. If empty, a name will be automatically generated like this:
  'transmission_watch_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "watch_volume_driver" {
  type        = string
  description = "Storage driver for the watch volume."
  default     = "local"
}

variable "watch_volume_driver_opts" {
  type        = map(any)
  description = "Storage driver options for the watch volume."
  default     = {}
}

variable "create_downloads_volume" {
  type        = bool
  description = "Create a volume for the '/downloads/default' directory."
  default     = true
}

variable "downloads_volume_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the downloads volume. If empty, a name will be automatically generated like this:
  'transmission_downloads_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "downloads_volume_driver" {
  type        = string
  description = "Storage driver for the downloads volume."
  default     = "local"
}

variable "downloads_volume_driver_opts" {
  type        = map(any)
  description = "Storage driver options for the downloads volume."
  default     = {}
}

variable "container_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the transmission container. If empty, one will be generated like this:
  'transmission_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "use_ghcr" {
  type        = bool
  description = <<-DESCRIPTION
  Whether to use GitHub container registry for getting the container image instead of Docker Hub.
  DESCRIPTION
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels to attach to created resources that support labels."
  default     = {}
}
