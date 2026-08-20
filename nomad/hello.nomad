job "hello" {
  datacenters = ["dc1"]
  type        = "service"

  group "hello-group" {
    count = 1

    network {
      mode = "bridge"
    }

    task "hello-task" {
      driver = "docker"

      config {
        image = "hello-devops:latest"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
