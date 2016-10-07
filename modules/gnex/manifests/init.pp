#Install packages necessary for compiling and clone the right repos
class gnex(){

  Exec {
    path      => [ '/usr/bin', '/bin'],
    logoutput => on_failure,
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
  }

  exec { 'install repo':
    cwd     => '/usr/local/bin',
    command => 'curl https://storage.googleapis.com/git-repo-downloads/repo >repo',
    creates => '/usr/local/bin/repo',
    require => Package[$packages],
  }

  file { 'chmod repo':
    path    => '/usr/local/bin/repo',
    mode    => '0755',
    require => Exec['install repo'],
  }

  exec { 'init repo':
    cwd     => '/home/buildbot/android/system',
    command => '/usr/local/bin/repo init -u https://github.com/CyanogenMod/android.git -b cm-13.0 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips,-exynos5,-intel,-eclipse,-device',
    user    => 'buildbot',
    group   => 'buildbot',
    creates => '/home/buildbot/android/system/.repo',
    timeout => 0,
    require => [ File['chmod repo'], File['create build dirs'], File['create gitconfig'] ],
  }

  file { 'create local_manifests dir' :
    path    => '/home/buildbot/android/system/.repo/local_manifests',
    ensure  => 'directory',
    owner   => 'buildbot',
    group   => 'buildbot',
    require => Exec['init repo'],
  }

  # Add Ziyans device tree
  file { 'copy roomservice.xml' :
    path    => "/home/buildbot/android/system/.repo/local_manifests/roomservice.xml",
    ensure  => 'present',
    source  => "puppet:///modules/gnex/roomservice.xml",
    owner   => 'buildbot',
    group   => 'buildbot',
    mode    => '0600',
    require => File['create local_manifests dir'],
  }

  #This takes a long time (approx 5.5 GB)
  exec { 'sync repo':
    cwd     => '/home/buildbot/android/system',
    command => '/usr/local/bin/repo sync -j2 -c',
    user    => 'buildbot',
    group   => 'buildbot',
    timeout => 0,
    require => File['copy roomservice.xml'],
  }

  #Put some extra commands on the PATH and compile the code
  exec { 'brunch':
    cwd         => '/home/buildbot/android/system',
    environment => ["HOME=/home/buildbot", "USER=buildbot"],
    command     => "/bin/bash -c 'source build/envsetup.sh;brunch maguro'",
    user        => 'buildbot',
    group       => 'buildbot',
    timeout     => 0,
    require     => Exec['sync repo'],
  }

}
