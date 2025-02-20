#!/bin/bash

# installing apache
echo "sudo apt update"
sudo apt update
echo "sudo apt install apache2 php libapache2-mod-php php-mysql -y"
sudo apt install apache2 php libapache2-mod-php php-mysql -y 
echo "sudo systemctl start apache2"
sudo systemctl start apache2  
echo "sudo systemctl enable apache2"
sudo systemctl enable apache2

echo "made index.php the first option in /etc/apache2/mods-enabled/dir.conf"
echo "DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm" > /etc/apache2/mods-enabled/dir.conf
echo "sudo systemctl restart apache2"
sudo systemctl restart apache2

echo "domain name:"
read domain
echo "sudo mkdir /var/www/$domain"
sudo mkdir /var/www/$domain
echo "sudo chown -R $USER:$USER /var/www/$domain"
sudo chown -R $USER:$USER /var/www/$domain

echo "added the domain to /etc/apache2/sites-available/$domain.conf"
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

echo "sudo a2ensite $domain"
sudo a2ensite $domain
echo "sudo a2dissite 000-default"
sudo a2dissite 000-default
echo "sudo apache2ctl configtest"
sudo apache2ctl configtest
echo "sudo systemctl reload apache2"
sudo systemctl reload apache2

echo "mySQL username:"
read username
echo "password:"
read passwd
echo "database name:"
read database_name
echo "table name:"
read table_name

echo "index.php now reads from the database, file: /var/www/$domain/index.php"
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
