provider "yandex" {
  cloud_id  = "b1g85rkpqt0ukuce35r3"
  folder_id = "b1g0muq63s1j2m4h5oab"
  zone      = "ru-central1-a"
  #token = var.token
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}