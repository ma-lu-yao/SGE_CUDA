## Install

1. modfiy /etc/sysconfig/gridengine or  /etc/sysconfig/gridengine-8.1.9

2. Config sge

```qconf -mc command

#name               shortcut   type        relop requestable consumable default  urgency

ngpus                 gpu        INT         <=    YES         YES        0        0


modify exec host, add complex_values by command (for each GPU node):

qconf -me node01.abc.org

complex_values        ngpus=4
```

3. start mysql server by command:
```
sudo systemctl start mysql
mysql -u root
run sql in mariadb command line:
CREATE DATABASE sgecuda ;
GRANT ALL PRIVILEGES ON sgecuda.* to cuda@'localhost' identified by 'YOUR_PASSWORD';
FLUSH PRIVILEGES;
```
4. Fill the data to MySQL Server
Edit /usr/share/sgecuda/generate_SQL.sh  ,modify the FQDN(A fully qualified domain name) line and run this script.
``` /usr/share/sgecuda/generate_SQL.sh > sgecuda.sql ```
``` mysql -u sgecuda sgecuda -p < sgecuda.sql ```

5. Generate RPM with sgecuda.spec ,RPM file list:
```
/etc/httpd/conf.d/sgecuda.conf
/run/sgecuda/
/usr/lib/systemd/system/sgecuda.service
/usr/sbin/sgecuda.sh
/usr/share/doc/sgecuda-qmaster-0.6
/usr/share/doc/sgecuda-qmaster-0.6/README.md
/usr/share/doc/sgecuda-qmaster-0.6/filldata.sh
/usr/share/sgecuda/index.php

```
6. Start Apache httpd / sgecuda 

version 0.6

Author: maluyao@gmail.com
