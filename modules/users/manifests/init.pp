class users()
{
  user { 'buildbot':
    ensure     => present,
    managehome => true,
    groups     => ['admin'],
    shell      => '/bin/bash';
  }

  #We have to do this as we are mounting a dir in the home dir before the user is created
  file { 'Chgrp home dir' :
    path    => '/home/buildbot',
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => User['buildbot'],
  }

  file { 'create .bashrc':
    ensure  => present,
    path    => '/home/buildbot/.bashrc',
    content => template('gnex/bashrc.erb'),
    owner   => 'buildbot',
    group   => 'buildbot',
    mode    => '0755',
    require => User['buildbot'],
  }

  file { 'create gitconfig' :
    ensure  => present,
    content => "[user]\nemail = you@example.com\nname = Your Name\n[color]\nui = auto",
    path    => '/home/buildbot/.gitconfig',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => User['buildbot'],
  }

  #Create Xauth files to allow connecting to display with Xming
  file { '/home/vagrant/.Xauthority':
    ensure  => 'present',
    replace => 'no', #Keep existing file if it already exists
    content => '',
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => '0644',
    require => User['buildbot'],
  }

  file { '/home/buildbot/.Xauthority':
    ensure  => 'present',
    replace => 'no', #Keep existing file if it already exists
    content => '',
    owner   => 'buildbot',
    group   => 'buildbot',
    mode    => '0644',
    require => User['buildbot'],
  }

  #Make dirs for the build env
  file { '/home/buildbot/android':
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => User['buildbot'],
  }

  file { 'create build dirs' :
    path    => '/home/buildbot/android/system',
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => File['/home/buildbot/android'],
  }

}