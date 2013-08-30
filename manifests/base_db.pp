include ntpd
include motd
include db
include createdb
include addhosts
include addtostartup
include firewall

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
      content => template('/tmp/vagrant-puppet/manifests/motd/motd.db.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
    }
}

class db {
    $neededpackages = [ "mysql", "mysql-server"]
    package { $neededpackages:
      ensure => installed
    }
    file    {'/etc/my.cnf':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/mysql/my.cnf.erb'),
      owner   => 'root',
      mode    => '644',
    }
    service { "mysqld":
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      require => Package["mysql-server"],
      restart => true;
    }
}

class createdb {
    exec { "create-ezp-db":
      command => "/usr/bin/mysql -uroot -e \"create database ezp character set utf8; grant all on ezp.* to ezp@'localhost' identified by 'ezp';grant all on ezp.* to ezp@'10.0.5.2' identified by 'ezp';grant all on ezp.* to ezp@'10.0.5.3' identified by 'ezp';grant all on ezp.* to ezp@'10.0.5.4' identified by 'ezp';\"",
      require => Service["mysqld"],
      returns => [ 0, 1, '', ' ']
    }
}

class addhosts {
    file    {'/etc/hosts':
      ensure  => file,
      content => template('/tmp/vagrant-puppet/manifests/hosts/hosts.db.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644',
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

class addtostartup {
    exec    { "add mysql to startup":
      command => "/sbin/chkconfig --add mysqld",
      path    => "/usr/local/bin/:/bin/",
      require => Package["mysql-server"]
    } ~>
    exec    { "add mysql":
      command => "/sbin/chkconfig mysqld on",
      path    => "/usr/local/bin/:/bin/",
      require => Package["mysql-server"]
    }
}