provider "yandex" {
  cloud_id  = "b1grm60bq04il7nqbus8"
  folder_id = "b1g8hoqkqlg8pq0dg85k"
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