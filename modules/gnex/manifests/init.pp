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
    content => template('gnex/bashrc.erb'),
    owner   => 'buildbot',
    group   => 'buildbot',
    mode    => '0755',
    require => User['buildbot'],
  }

  file { 'create gitconfig' :
    ensure  => present,
    content => '[user]\nemail = you@example.com\nname = Your Name\n[color]\nui = auto',
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

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }

  $packages = [
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
              ]
  package { $packages:
    ensure => 'installed',
    notify => Exec['install repo']
  }

  exec { 'install repo':
    cwd     => '/usr/local/bin',
    command => 'curl https://storage.googleapis.com/git-repo-downloads/repo >repo',
    creates => '/usr/local/bin/repo',
  }

  file { '/usr/local/repo':
    mode    => '0755',
    require => Exec['install repo'],
  }

  #Make dirs for the build env
  file { '/home/buildbot/android':
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => User['buildbot'],
  }
  file { '/home/buildbot/android/system':
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => File['/home/buildbot/android'],
  }

  exec { 'init repo':
    cwd     => '/home/buildbot/android/system',
    command => '/usr/local/bin/repo init -u https://github.com/CyanogenMod/android.git -b cm-13.0 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips,-exynos5,-intel,-eclipse,-device',
    creates => '/home/buildbot/android/system/.repo',
    require => [ File['/usr/local/repo'], File['create build dirs'], File['create gitconfig'] ]
  }

  #This takes a long time (approx 5.5 GB)
  exec { 'sync repo':
    cwd     => '/home/buildbot/android/system',
    command => '/usr/local/bin/repo sync -j2 -c',
    require => Exec['init repo']
  }

  #Put some extra commands on the PATH
  exec { 'sync repo':
    cwd     => '/home/buildbot/android/system',
    command => 'source build/envsetup.sh',
    require => Exec['sync repo']
  }

  # get prebuilt
  # cd ~/android/system/vendor/cm
  # ./get-prebuilts

}
