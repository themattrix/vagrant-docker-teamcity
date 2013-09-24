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

package { 'apparmor-utils':
    ensure => installed,
}

exec { 'lxc-complain':
    path    => ['/usr/sbin'],
    command => 'aa-complain /etc/apparmor.d/lxc/lxc-default /usr/bin/lxc-start',
    require => Package['apparmor-utils'],
    notify  => Exec['reload-apparmor'],
}

exec { 'reload-apparmor':
    path        => ['/usr/sbin', '/usr/local/sbin', '/usr/bin', '/usr/local/bin', '/bin'],
    command     => 'service apparmor reload',
    refreshonly => true,
}
