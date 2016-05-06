class system-update()
{
  exec { 'apt-get-update':
    command => '/usr/bin/apt-get -y update',
    timeout => 3600;
  }

  $dependencies = ['dos2unix', 'htop', 'vim', 'x11-apps', 'libXtst6', 'libXi6', 'xauth', 'openjdk-7-jdk']
  package { $dependencies:
    ensure  => installed,
    require => Exec['apt-get-update'],
  }
  
  exec { 'apt-get-autoremove':
    command => '/usr/bin/apt-get -y autoremove',
    timeout => 3600,
    require => Package[$dependencies],
  }  
}
