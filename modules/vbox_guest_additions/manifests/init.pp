class vbox_guest_additions {

  include vbox_guest_additions::depends

  exec { "restart":
    path        => ["/sbin"],
    command     => "shutdown -r now",
    refreshonly => true,
  }

  Class["vbox_guest_additions::depends"] ~> Exec["restart"]
}
