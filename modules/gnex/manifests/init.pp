#Install packages necessary for compiling and clone the right repos
class gnex(){

  Exec {
    path => [ '/usr/bin', '/bin']
  }

  user { 'buildbot':
    ensure     => present,
    managehome => true,
    groups     => ['admin'],
    shell      => '/bin/bash';
  }

  file { 'create .bashrc':
    ensure  => present,
    path    => '/home/buildbot/.bashrc',
    content => template('buildbot/bashrc.erb'),
    owner   => 'buildbot',
    group   => 'buildbot',
    mode    => '0755',
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

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }

  package { 'dependencies':
    [
      'bison',
      'build-essential',
      'ccache',
      'curl',
      'flex',
      'g++-multilib',
      'gcc-multilib',
      'git',
      'gnupg',
      'gperf',
      'lib32ncurses5-dev',
      'lib32readline-gplv2-dev',
      'lib32z1-dev',
      'lib32z-dev',
      'libc6-dev-i386',
      'libesd0-dev',
      'libgl1-mesa-dev',
      'liblz4-tool',
      'libncurses5-dev',
      'libsdl1.2-dev',
      'libwxgtk2.8-dev',
      'libx11-dev',
      'libxml2',
      'libxml2-utils',
      'lzop',
      'maven',
      'pngcrush',
      'schedtool',
      'squashfs-tools',
      'unzip',
      'x11proto-core-dev',
      'xsltproc',
      'zip',
      'zlib1g-dev'
    ]:
    ensure => installed,
  }

  #Make dirs for the build env
  file { 'create build dirs':
        [
          '/home/buildbot/android',
          '/home/buildbot/android/system'
        ]:
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => User['buildbot'],
  }

  exec { 'install repo':
    cwd     => '/usr/local/bin',
    command => 'curl https://storage.googleapis.com/git-repo-downloads/repo >repo',
    creates => '/usr/local/bin/repo',
    require => Package['dependencies']
  }

  file { '/usr/local/repo':
    mode    => '0775',
    require => Exec['install repo'],
  }
  
  file { '/home/vagrant/.gitconfig' :
    source => '/vagrant/gitconfig',
    owner  => 'vagrant',
    group  => 'vagrant'
  }

  # repo init/sync:
  # repo init -u git://github.com/CyanogenMod/android.git -b cm-11.0
  # repo sync

  # get prebuilt
  # cd ~/android/system/vendor/cm
  # ./get-prebuilts

}
