class jdk8(
    $java_archive = 'jdk-8u77-linux-x64.tar.gz',
	$java_url     = 'http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz',
    $java_home    = '/usr/lib/jvm/jdk1.8.0_77',
    $java_folder  = 'jdk1.8.0_77')
{

  Exec {
    path => [ '/usr/bin', '/bin', '/usr/sbin']
  }

  exec {'download jdk':
    command => "wget -O /tmp/installers/$java_archive --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' $java_url",
    creates => "/tmp/installers/$java_archive",
  }

  exec { 'extract jdk':
    cwd     => '/tmp',
    command => "cp installers/${java_archive} .;tar -zxvf ${java_archive}",
    creates => "/tmp/${java_archive}",
    require => Exec['download jdk'],
  }

  file { '/usr/lib/jvm' :
    ensure  => directory,
    owner   => vagrant,
    require => Exec['extract jdk'],
  }

  exec { 'move jdk':
    cwd     => '/tmp',
    command => "mv ${java_folder} /usr/lib/jvm/",
    creates => $java_home,
    require => File['/usr/lib/jvm'],
  }

  exec {'install java':
    logoutput => true,
    command   => "update-alternatives --verbose --install /bin/java java ${java_home}/bin/java 1",
    require   => Exec['move jdk'],
  }

  exec {'set java':
    logoutput => true,
    command   => "update-alternatives --verbose --set java ${java_home}/bin/java",
    require   => Exec['install java'],
  }

  exec {'install javac':
    logoutput => true,
    command   => "update-alternatives --verbose --install /bin/javac javac ${java_home}/bin/javac 1",
    require   => Exec['move jdk'],
  }

  exec {'set javac':
    logoutput => true,
    command   => "update-alternatives --verbose --set javac ${java_home}/bin/javac",
    require   => Exec['install javac'],
  }

  file { '/etc/profile.d/java.sh':
    ensure  => present,
    content => "export JAVA_HOME=${java_home}\nexport PATH=\$PATH:\$JAVA_HOME/bin",
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }
}