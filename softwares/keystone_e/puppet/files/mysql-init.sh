#!/bin/bash

#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

#confirm if db keystone exists.
mysql -uroot -popenstack -e "use keystone"
if [ $? = 0 ]; then
    echo "db keystone existed."
    exit 0
fi

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/my.cnf
service mysql restart

mysql -uroot -popenstack -e "CREATE DATABASE keystone;"
mysql -uroot -popenstack -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"

#confirm if db glance exists.
mysql -uroot -popenstack -e "use glance"
if [ $? = 0 ]; then
    echo "db glance existed."
    exit 0
fi

mysql -uroot -popenstack -e "CREATE DATABASE glance;"
mysql -uroot -popenstack -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"

#confirm if db nova exists.
mysql -uroot -popenstack -e "use nova"
if [ $? = 0 ]; then
    echo "db nova existed."
    exit 0
fi

mysql -uroot -popenstack -e "CREATE DATABASE nova;"
mysql -uroot -popenstack -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -popenstack -e "SET PASSWORD FOR 'root'@'%' = PASSWORD('openstack');"

echo "finished"
