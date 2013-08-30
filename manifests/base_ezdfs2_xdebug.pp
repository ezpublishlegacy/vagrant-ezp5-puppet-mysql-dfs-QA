include ntpd
include apachephp
include apc
include xdebug
include imagick
include ezfind
include virtualhosts
include firewall
include composer
include motd
include addhosts
include addtostartup
include nfs_2
include git
include svn
include ftp
include ezsi

class ezsi {
    user { "esitest":
      comment => "Creating user esitest",
      home => "/home/esitest",
      ensure => present,
      shell => "/bin/bash",
    } ~>
    file { "/home/esitest":
      ensure => "directory",
      owner  => "esitest",
      group  => "esitest",
      mode   => '750',  
    }    
    file { "/etc/httpd/conf.d/filter.conf":
      ensure => file,
      content => template('/tmp/vagrant-puppet/manifests/httpd/filter.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '640',
    }
}

class ftp {
    $neededpackages = ["vsftpd", "ftp"]
    package { $neededpackages:
      ensure => installed,
    } ~>
    exec { "chkconfig vsftp on":
      command => "/sbin/chkconfig vsftp on",
      path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      returns => [ 0, 1, '', ' ']
    } ~>
    exec { "service vsftp start":
      command => "/sbin/service vsftp start",
      path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      returns => [ 0, 1, '', ' ']
    } ~>
    exec { "setsebool -P ftp_home_dir=1":
      command => "/usr/sbin/setsebool -P ftp_home_dir=1",
      path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      returns => [ 0, 1, '', ' ']
    } ~>
    service { "vsftpd":
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      require => Package["vsftpd"],
      restart => true;
    }    
}

class svn {
    package { "subversion":
      ensure => installed,
    } ~>
    file { "/home/vagrant/.subversion":
      ensure => "directory",
      owner  => "vagrant",
      group  => "vagrant",
      mode   => '750',  
    } 
    file { "/home/vagrant/.subversion/config":
      ensure => file,
      content => template('/tmp/vagrant-puppet/manifests/svn/config.erb'),
      owner   => 'vagrant',
      group   => 'vagrant',
      mode    => '750',
    }
}

class git {
    package { "git":
      ensure => installed,
    }
}

class nfs_2 {
    $neededpackages = ["nfs-utils", "nfs-utils-lib", "rpcbind"]
    package { $neededpackages:
      ensure => installed,
    } ~>
    file { "/etc/sysconfig/nfs":
      ensure => file,
      content => template("/tmp/vagrant-puppet/manifests/nfs/nfs.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '644',     
    } ~>
    file { "/mnt/ezdfs":
      ensure => "directory",
      owner  => "vagrant",
      group  => "vagrant",
      mode   => '777',  
    } ~>
    file { "/etc/fstab":
      ensure => file,
      content => template('/tmp/vagrant-puppet/manifests/fstab/fstab.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',       
    } ~>
    service { "rpcbind":
      enable => true,
      ensure => running,
    } ~>
    service { "nfs":
      enable => true,
      ensure => running,
    } ~>
    service { "nfslock":
      enable => true,
      ensure => running,
    } ~>
    exec { "mount":
      command => "/bin/mount  10.0.5.2:/mnt/ezdfs /mnt/ezdfs",
      path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      refreshonly => true,
      returns => [ 0, 1, 32, '', ' ']      
    }
}

class ntpd {
    package { "ntpdate.x86_64": 
      ensure => installed 
    }
    service { "ntpd":
      ensure => running,
    }
}

class motd {
    file    {'/etc/motd':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/motd/motd.xdebug.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
    }
}

class apachephp {
    $neededpackages = [ "httpd", "php", "php-cli", "php-gd" ,"php-mysql", "php-pear", "php-xml", "php-mbstring", "php-pecl-apc", "php-process", "curl.x86_64", "mysql" ]
    package { $neededpackages:
        ensure => present,
    } ~>
    file    {'/etc/httpd/conf.d/01.accept_pathinfo.conf':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/httpd/01.accept_pathinfo.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
    } ~>
    file    {'/etc/php.d/php.ini':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/php/php.ini.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
    } 
}

class imagick {
    $neededpackages = [ "ImageMagick", "ImageMagick-devel", "ImageMagick-perl" ]
    package { $neededpackages:
      ensure => installed
    }
    exec    { "update-channels":
      command => "pear update-channels",
      path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
      require => Package['php-pear'],
      returns => [ 0, 1, '', ' ']
    } ~>
    exec    { "install imagick":
      command => "pecl install imagick",
      path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
      require => Package['php-pear'],
      returns => [ 0, 1, '', ' ']
    }
}

class apc {
    $neededpackages = [ "php-devel", "httpd-devel", "pcre-devel.x86_64", "php-pecl-apc.x86_64" ]
    package { $neededpackages:
      ensure => installed
    } ~>
    file    {'/etc/php.d/apc.ini':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/php/apc.ini.erb'),
    }
}

class ezfind {
    package { "java-1.6.0-openjdk.x86_64":
      ensure => installed
    }
}

class virtualhosts {
    file    {'/etc/httpd/conf.d/02.namevirtualhost.conf':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/virtualhost/02.namevirtualhost.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      require => Package["httpd"],
    }
    file    {'/etc/httpd/conf.d/ezp5.conf':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/virtualhost/ezp5.xdebug.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      require => Package["httpd"],
    }
}

class firewall {
    file    {'/etc/sysconfig/iptables':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/iptables/iptables.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '600',
    }
    service { iptables:
      ensure => running,
      subscribe => File["/etc/sysconfig/iptables"],
    }
}

class xdebug {
    exec    { "install xdebug":
      command => "pear install pecl/xdebug",
      path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
      require => Package['php-pear'],
      returns => [ 0, 1, '', ' ']
    }
    file    {'/etc/php.d/xdebug.ini':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/php/xdebug.ini.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      require => Package["php"],
    }
}

class composer {
    exec    { "get composer":
      command => "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin",
      path    => "/usr/local/bin:/usr/bin/",
      require => Package["httpd"],
      returns => [ 0, 1, '', ' ']
    } ~>
    exec    { "link composer":
      command => "/bin/ln -s /usr/local/bin/composer.phar /usr/local/bin/composer.phar",
      path    => "/usr/local/bin:/usr/bin/:/bin",
      returns => [ 0, 1, '', ' ']
    }
}

class addhosts {
    file    {'/etc/hosts':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/hosts/hosts.xdebug.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
    }
}

class addtostartup {
    exec    { "add httpd to startup":
      command => "/sbin/chkconfig httpd on",
      path    => "/usr/local/bin/:/bin/",
      require => Package["httpd", "php", "php-cli", "php-gd" ,"php-mysql", "php-pear", "php-xml", "php-mbstring", "php-pecl-apc", "php-process", "curl.x86_64"]
    } 
    exec    { "add rpcbind to startup":
      command => "/sbin/chkconfig rpcbind on",
      path    => "/usr/local/bin/:/bin/",
      require => Package["rpcbind"]
    } ~>
    exec    { "add nfs to startup":
      command => "/sbin/chkconfig nfs on",
      path    => "/usr/local/bin/:/bin/",
      require => Package["nfs-utils"]
    } ~>
    exec    { "add nfslock to startup":
      command => "/sbin/chkconfig nfslock on",
      path    => "/usr/local/bin/:/bin/",
      require => Package["nfs-utils"]
    } 
}
