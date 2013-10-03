class docker_apt_prereq {

  exec { 'add-docker-gpg-key':
    path    => ['/usr/bin', '/bin'],
    command => "wget -q -O - https://get.docker.io/gpg | apt-key add -",
    unless  => "apt-key list | grep -s -q Docker",
  }

  file { 'docker-apt-list':
    ensure  => file,
    path    => "/etc/apt/sources.list.d/docker.list",
    content => "deb http://get.docker.io/ubuntu docker main",
  }
}
