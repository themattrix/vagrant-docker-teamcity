class vbox_guest_additions::depends {

  package { "linux-headers-generic-lts-raring":
    ensure => installed,
  }

  package { "dkms":
    ensure => installed,
  }

  $vbox_version = "4.2.18"
  $vbox_guest_additions_iso = "VBoxGuestAdditions_${vbox_version}.iso"
  $vbox_guest_additions_src = "http://dlc.sun.com.edgesuite.net/virtualbox/${vbox_version}/${vbox_guest_additions_iso}"
  $vbox_guest_additions_dst = "/root/${vbox_guest_additions_iso}"

  $installer       = "guest_additions.sh"
  $installer_src   = "vbox_guest_additions/${installer}.erb"
  $installer_dst   = "/root/${installer}"
  $queue_installer = "/bin/sed -i -E 's#^exit 0#[ -x ${installer_dst} ] \\&\\& ${installer_dst}#' /etc/rc.local"

  exec { "queue":
    command => "${queue_installer}",
  }

  exec { "download":
    path    => ["/usr/bin"],
    command => "wget -O ${vbox_guest_additions_dst} ${vbox_guest_additions_src}",
    creates => "${vbox_guest_additions_dst}",
    timeout => 1800,
    tries   => 2,
  } ->

  file { "installer":
    path    => "${installer_dst}",
    ensure  => file,
    mode    => "700",
    content => template("${installer_src}"),
  }
}
