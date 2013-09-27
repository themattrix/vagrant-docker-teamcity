
### High-level relationships

# Update apt before installing any packages.
Exec['apt-get update'] -> Package <| |>

### Update apt

# TODO: necessary?
#exec { 'add-docker-gpg-key':
#    path    => ['/usr/bin', '/bin'],
#    command => "wget -q -O - https://get.docker.io/gpg | apt-key add -",
#    unless  => "apt-key list | grep -s -q Docker",
#}

exec { 'apt-get update':
    path    => ['/usr/bin'],
#    require => Exec['add-docker-gpg-key'],
}


### Install >= 3.8 kernel for Docker

package { 'linux-image-generic-lts-raring':
    ensure => installed,
} #~>
#exec { 'restart':
#    path        => ['/sbin'],
#    command     => "shutdown -r now",
#    refreshonly => true,
#}


# TODO: install VBoxGuestAdditions:
#        if ENV["VAGRANT_DEFAULT_PROVIDER"].nil? && ARGV.none? { |arg| arg.downcase.start_with?("--provider") }
#            pkg_cmd << "apt-get install -q -y linux-headers-generic-lts-raring dkms; " \
#                "echo 'Downloading VBox Guest Additions...'; " \
#                "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/4.2.18/VBoxGuestAdditions_4.2.18.iso; "
#            # Prepare the VM to add guest additions after reboot
#            pkg_cmd << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_4.2.18.iso /mnt\n" \
#                "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
#                "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
#                "chmod 700 /root/guest_additions.sh; " \
#                "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; "
#        end

package { 'linux-headers-generic-lts-raring':
    ensure => installed,
}

package { 'dkms':
    ensure => installed,
}

$vbox_version = "4.2.18"

exec { 'dl-vbox-guest-additions':
    path    => ['/usr/bin'],
    command => "wget -o /root/VBoxGuestAdditions_${vbox_version}.iso http://dlc.sun.com.edgesuite.net/virtualbox/${vbox_version}/VBoxGuestAdditions_${vbox_version}.iso",
}

file { '/root/guest_additions.sh':
    ensure  => file,
    mode    => '700',
    content => "
        mount -o loop,ro /home/vagrant/VBoxGuestAdditions_${vbox_version}.iso /mnt
        echo yes | /mnt/VBoxLinuxAdditions.run
        umount /mnt
        rm /root/guest_additions.sh",
}

exec { '//':
    command => "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local",
}
