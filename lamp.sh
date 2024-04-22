#!/bin/bash


# To update and upgrade the server
sudo apt update and sudo apt upgrade -y


# LAMP Stack Installation
sudo apt-get install apache2 -y

sudo apt-get install ansible -y

sudo apt-get install mysql-server  -y

sudo aptinstall python-software-properties -y

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get update

sudo apt-get install php8.2

sudo apt-get install sudo apt-get install php8.2 php8.2-cli php8.2-common php8.2-zip php8.2-soap php8.2-sodium php8.2-tidy php8.2-xsl php8.2-gd php8.2-mbstring php8.2-tokenizer php8.2-curl php8.2-mysql php8.2-bcmath php8.2-xm
l php8.2-intl php8.2-sqlite3 php8.2-dom -y

sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini

sudo systemctl restart apache2

sudo systemctl restart php8.2


# INSTALL COMPOSER FOR PHP


sudo apt install curl -y

sudo curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/local/bin/composer

composer --version



# APACHE2 CONFIGURATION

cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName 192.168.30.10
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF


sudo a2enmod rewrite

sudo a2ensite laravel.conf

sudo systemctl restart apache2




# GIT CLONE LARAVEL APPLICATION AND IT'S DEPENDENCIES


mkdir /var/www/html/laravel && cd /var/www/html/laravel

cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git

cd /var/www/html/laravel && composer install --no-dev < /dev/null

sudo chown -R www-data:www-data /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel/storage

sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

cd /var/www/html/laravel && sudo cp .env.example .env

php artisan key:generate




# CONFIGURING MYSQL: CREATING USER AND PASSWORD



echo "Creating MySQL user and database"
PASS=$2
if [ -z "$2" ]; then
          PASS=`openssl rand -base64 8`
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Username:   $1"
echo "Database:   $1"
echo "Password:   $PASS"





# EXECUTE KEY GENERATE AND MIGRATE COMMAND FOR PHP

sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=emehinolakings/' /var/www/html/laravel/.env

sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=emehinolakings/' /var/www/html/laravel/.env

sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=kings420@/' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel && php artisan migrate
