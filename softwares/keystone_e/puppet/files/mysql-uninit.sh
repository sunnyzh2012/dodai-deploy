# Drop databases from mysql

MYSQL_PASS=openstack

for D in keystone glance nova
do
    #mysqladmin -f -uroot -p$MYSQL_PASS drop $D
    mysql -uroot -p$MYSQL_PASS -e "drop database $D;"
done

echo "finished"
