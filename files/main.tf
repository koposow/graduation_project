terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = "b1gtful09h3cuhpevice"
  folder_id = "b1g3jp8vcee18hao4u57"
}
variable "yandex_token" {
  description = "Yandex Cloud API token"
}

variable "subnet_id_zone_a" {
  description = "Subnet ID for zone A"
}

variable "subnet_id_zone_b" {
  description = "Subnet ID for zone B"
}

variable "yandex_folder_id" {
  description = "Yandex Cloud folder ID"
}
resource "yandex_compute_instance" "web_server_1" {
  name         = "web-server-1"
  zone         = "ru-central1-a"
  platform_id  = "standard-v3"
  folder_id = "b1g3jp8vcee18hao4u57"
    metadata = {
  user-data = "${file("meta.yml")}"
}
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd88r89var8ukrlbmaki"
      size     = 10
    }
  }
  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = "e9bet8fr4orpdlhvf5vv"
    nat       = true
  }
}

resource "yandex_compute_instance" "web_server_2" {
  name         = "web-server-2"
  zone         = "ru-central1-b"
  platform_id  = "standard-v3"
  folder_id = "b1g3jp8vcee18hao4u57"
  metadata = {
  user-data = "${file("meta.yml")}"
}
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd88r89var8ukrlbmaki"
      size     = 10
    }
  }
  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = "e2lj7vk9hdqso4qn7bks"
    nat       = true
  }
}

resource "yandex_lb_target_group" "target_group" {
  name      = "web-servers-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = "Ye9bet8fr4orpdlhvf5vv"
    address   = yandex_compute_instance.web_server_1.network_interface.0.ip_address
    # port      = 80
  }

  target {
    subnet_id = "e2lj7vk9hdqso4qn7bks"
    address   = yandex_compute_instance.web_server_2.network_interface.0.ip_address
    # port      = 80
  }
}

#resource "yandex_alb_backend_group" "backend_group" {
 # name              = "web-servers-backend-group"
  # region_id         = "ru-central1"
  # target_group_id   = yandex_lb_target_group.target_group.id

 
#}

#resource "yandex_alb_http_router" "http_router" {
 # name      = "http-router"
  # region_id = "ru-central1"
  #folder_id = "b1g3jp8vcee18hao4u57"



#}

#resource "yandex_lb_network_load_balancer" "load_balancer" {
 # name      = "web-servers-load-balancer"
 # region_id = "ru-central1"
 # folder_id = "b1g3jp8vcee18hao4u57"

 # listener {
 #   name     = "http-listener"
 #   port     = 80
 #   protocol = "HTTP"
 # }

 # attached_target_group {
 #   target_group_id = yandex_lb_target_group.target_group.id
 # }
#variable "yandex_token" {}