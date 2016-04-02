class system-update()
{
  exec { 'apt-get-update':
    command => '/usr/bin/apt-get -y update',
    timeout => 3600;
  }

  package {
    ['dos2unix', 'htop', 'vim', 'x11-apps', 'libXtst6', 'libXi6', 'xauth']:
    ensure => installed,
  }
}
