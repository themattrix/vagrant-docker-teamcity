class docker_prereq {

  include docker_apt_prereq

  # Update apt before installing any packages
  Class["docker_apt_prereq"] -> Exec["apt-get update"] -> Package <| |>

  exec { "apt-get update":
    path => ["/usr/bin"],
  }

  # Install >= 3.8 kernel for Docker
  package { "linux-image-generic-lts-raring":
    ensure => installed,
  }
}
