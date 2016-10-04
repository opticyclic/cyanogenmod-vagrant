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

  #Add swap space as compiling uses a lot of RAM that we don't have in the VM
  file { 'copy increase_swap.sh' :
    path    => "/tmp/increase_swap.sh",
    ensure  => 'present',
    source  => "puppet:///modules/system-update/increase_swap.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  exec { 'add swap':
    cwd     => '/tmp',
    command => '/tmp/increase_swap.sh',
    user    => 'root',
    group   => 'root',
    require => File['copy increase_swap.sh'],
  }  
}
