
### Packages required by or related to Docker

package { 'lxc-docker':
    ensure => installed,
}

package { 'apparmor-utils':
    ensure => installed,
}


### Useful development packages to have

package { 'vim':
    ensure => installed,
}

package { 'git':
    ensure => installed,
}

package { 'socat':
    ensure => installed,
}

package { 'tmux':
    ensure => installed,
}

exec { 'lxc-complain':
    path    => ['/usr/sbin'],
    command => "aa-complain /etc/apparmor.d/lxc/lxc-default /usr/bin/lxc-start",
    require => [Package['apparmor-utils'], Package['lxc-docker']],
} ~>
exec { 'reload-apparmor':
    path        => ['/usr/sbin', '/usr/local/sbin', '/usr/bin', '/usr/local/bin', '/bin'],
    command     => "service apparmor reload",
    refreshonly => true,
}
