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
  Transmission web interface. Choose one of:

  - "combustion-release"
  - "transmission-web-control"
  - "kettu"
  DESCRIPTION
  default     = "combustion-release"
}

variable "image_version" {
  type        = string
  description = <<-DESCRIPTION
  Container image version.
  Check https://github.com/orgs/linuxserver/packages/container/package/transmission.
  DESCRIPTION
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
  The restart policy of the container. Must be one of:
  - "no"
  - "on-failure"
  - "always"
  - "unless-stopped"
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
  volume will be attached to `/downloads/{dir_name}` if `dir_name` is not empty, or
  `/downloads/volume_name` otherwise.
  DESCRIPTION
  default     = []
}
