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

MYSQL_PASS=openstack

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/my.cnf
service mysql restart

USER_SUFFIX=dbadmin
PWD_SUFFIX=secret
for D in keystone glance nova
do
    #confirm if db $D exists.
    mysql -uroot -p$MYSQL_PASS -e "use $D"
    if [ $? = 0 ]; then
        echo "db $D existed."
        exit 0
    fi

    # Create Database if not exists.
    mysql -uroot -p$MYSQL_PASS -e "CREATE DATABASE $D;"
    mysql -uroot -p$MYSQL_PASS -e "CREATE USER ${D}${USER_SUFFIX}"
    mysql -uroot -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON $D.* TO '${D}${USER_SUFFIX}'@'%' WITH GRANT OPTION;"
    mysql -uroot -p$MYSQL_PASS -e "SET PASSWORD FOR '${D}${USER_SUFFIX}'@'%' = PASSWORD('${D}${PWD_SUFFIX}');"
done

echo "finished"
