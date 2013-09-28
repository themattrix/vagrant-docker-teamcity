
### High-level relationships

# Update apt before installing any packages, before rebooting
Exec['apt-get update'] -> Package <| |> -> Exec['restart']


### Update apt

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

exec { 'apt-get update':
    path    => ['/usr/bin'],
    require => [Exec['add-docker-gpg-key'], File['docker-apt-list']],
}


### Install >= 3.8 kernel for Docker

package { 'linux-image-generic-lts-raring':
    ensure => installed,
}


### Install VirtualBox Guest Additions

package { 'linux-headers-generic-lts-raring':
    ensure => installed,
}

package { 'dkms':
    ensure => installed,
}

$vbox_version = "4.2.18"
$vbox_guest_additions_iso = "VBoxGuestAdditions_${vbox_version}.iso"
$vbox_guest_additions_src = "http://dlc.sun.com.edgesuite.net/virtualbox/${vbox_version}/${vbox_guest_additions_iso}"
$vbox_guest_additions_dst = "/root/${vbox_guest_additions_iso}"

exec { 'dl-vbox-guest-additions':
    path    => ['/usr/bin'],
    command => "wget -O ${vbox_guest_additions_dst} ${vbox_guest_additions_src}",
    creates => "${vbox_guest_additions_dst}",
    timeout => 1800,
}

#file { 'dl-vbox-guest-additions':
#    ensure => file,
#    path   => "${vbox_guest_additions_dst}",
#    source => "/vagrant/${vbox_guest_additions_iso}",
#}

file { '/root/guest_additions.sh':
    ensure  => file,
    mode    => '700',
    content => "
        mount -o loop,ro ${vbox_guest_additions_dst} /mnt
        echo yes | /mnt/VBoxLinuxAdditions.run
        umount /mnt
        mv /root/guest_additions.sh /root/guest_additions.sh.ran",
}

exec { 'queue-vbox-guest-additions':
    path    => ['/bin'],
    command => "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local",
} ~>
exec { 'restart':
    path        => ['/sbin'],
    command     => "shutdown -r now",
    refreshonly => true,
    require     => [
        Exec['dl-vbox-guest-additions'],
        File['/root/guest_additions.sh'],
        Exec['queue-vbox-guest-additions']]
}
