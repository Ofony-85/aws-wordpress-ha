#!/bin/bash

# Update system
dnf update -y

# Install packages
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel php-gd php-mbstring php-xml mariadb105 amazon-efs-utils

# Start services
systemctl start httpd
systemctl enable httpd
systemctl start php-fpm
systemctl enable php-fpm

# Mount EFS
mkdir -p /var/www/html
echo "fs-0a77e5666c3d9882f:/ /var/www/html efs _netdev,tls,iam 0 0" >> /etc/fstab
mount -a

# Wait for mount
sleep 10

# Install WordPress (only once)
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
    
    # Create wp-config.php from scratch
    cd /var/www/html
    cat > wp-config.php << 'WPCONFIG'
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'WpSecure2024!');
define('DB_HOST', 'wordpress-db.c4tm2e0s4d3h.us-east-1.rds.amazonaws.com');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

$table_prefix = 'wp_';
define('WP_DEBUG', false);

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
WPCONFIG
    
    # Get and add security keys
    KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    # Replace the placeholder keys with real ones
    sed -i "/AUTH_KEY/,/NONCE_SALT/d" wp-config.php
    sed -i "/DB_COLLATE/a\\$KEYS" wp-config.php
    
    # Set permissions
    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html
fi

# Configure Apache
cat > /etc/httpd/conf.d/wordpress.conf << 'APACHECONF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

# Restart services
systemctl restart httpd
systemctl restart php-fpm
