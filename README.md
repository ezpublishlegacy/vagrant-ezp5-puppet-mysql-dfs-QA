# vagrant:ezp5:puppet:mysql:dfs

Prototype development machine for eZDFS for eZ Publish 5.x, provisioned with Puppet

## Stack & utilities:

- CentOS 6.4 x64
- 2 x Apache 2.2.15 
- 1 x MySQL 5.1.69
- PHP 5.3.3
- APC 3.1.9
- Xdebug 2.2.3 or not, this is your choice through Vagrantfile setup
- Composer
- eZ Publish 5 Community 2013.07

## Requirements:

- Vagrant >= 1.2.7 (http://vagrantup.com/)
- VirtualBox (https://www.virtualbox.org/) or VMWare (http://www.vmware.com/)

## Getting started:

- Clone this project to a directory 
- Run `$ vagrant up` from the terminal
- Wait (the first time will take a few minutes, as the base boxes are downloaded, and required packages are installed for the first time), get some coffee, on in this case lunch ;).
- Done! `$ ssh vagrant@10.0.5.x` to SSH into your newly created machines. The MOTD contains details on the database, hostnames, etc.
- By default Xdebug is enable, if you want to disable it, go to line 69, and 99, of Vagrantfile comment it and uncomment line 66, and 96. Don't forget to run `$ vagrant up` after
- You need to make a few changes in your personal xml configuration files:

```    
    - <siteaccesssettings matchorder="uri" adminhost="127.0.0.1">
    - <clusternode syncpath="vagrant@10.0.5.3:/var/www/html/ezpublish5" protocol='ssh' />
```
- To run a filter use the command:
    - time php tests/runtests.php --dsn mysqli://ezp:ezp@10.0.5.4/ezp --db-per-test --configuration=extension/selenium/configs/<CONFIGURATION>.xml --filter="admin2.html"

## Environment Details:

```
MySQL:
  hostname: db.ezp5.vagrant
  default ip: 10.0.5.4
  default database: ezp
  default db user: ezp
  default db user password: ezp

Apache/httpd: www root: /var/www/html

eZ Publish 5 Project:
  hostnames: 
            - http://ezdfs1.ezp5.vagrant:8080, and 
            - http://ezdfs2.ezp5.vagrant:8081
  ips: 
            - 10.0.5.2, and 
            - 10.0.5.3
  location: 
            - /var/www/html/ezpublish5

  environment: dev or prod, depending on the choosen configuration
```

## KNOWNED ISSUES

When you do vagrant up don't choose eth0, since this will result on the error /sbin/ifup eth1 2> /dev/null. This issue has already been reported https://github.com/mitchellh/vagrant/issues/1777

## COPYRIGHT
Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.

## LICENSE
http://www.gnu.org/licenses/gpl-2.0.txt GNU General Public License v2