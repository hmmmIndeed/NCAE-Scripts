#!/bin/bash

# installing apache
sudo apt update
sudo apt install apache2 php libapache2-mod-php php-mysql -y 
sudo systemctl start apache2  
sudo systemctl enable apache2

echo "DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm" > /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2

echo "domain name:"
read domain
sudo mkdir /var/www/$domain
sudo chown -R $USER:$USER /var/www/$domain

cat > /etc/apache2/sites-available/$domain.conf <<- EOM
<VirtualHost *:80>
  ServerName $domain
  ServerAlias www.$domain
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/$domain
  ErrorLog \$\{APACHE_LOG_DIR\}/error.log
  CustomLog \$\{APACHE_LOG_DIR\}/access.log combined
</VirtualHost>
EOM

sudo a2ensite $domain
sudo a2dissite 000-default
sudo apache2ctl configtest
sudo systemctl reload apache2

echo "mySQL username:"
read username
echo "password:"
read passwd
echo "database name:"
read database_name
echo "table name:"
read table_name

cat > /var/www/$domain/index.php <<- EOM
<?php
\$user = $username;
\$password = $passwd;
\$database = $database_name;
\$table = $table_name;

try {
  \$db = new PDO("mysql:host=localhost;dbname=\$database", \$user, \$password);
  echo "<h2>TODO</h2><ol>";
  foreach(\$db->query("SELECT content FROM \$table") as \$row) {
    echo "<li>" . \$row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException \$e) {
    print "Error!: " . \$e->getMessage() . "<br/>";
    die();
}
EOM
