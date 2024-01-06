provider "yandex" {
  cloud_id  = "b1g2d0vl3bm7e6bm9feg"
  folder_id = "b1gp1lnbr8gdrkl7b34h"
  zone      = "ru-central1-a"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
} 