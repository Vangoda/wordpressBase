# Start from PHP 7.4 ALpine Image
FROM php:7.4-alpine

# Add mlocatis php extension installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Copy default apache configuration
# COPY apache2 conf
COPY ./apache/apache2.conf /etc/apache2/apache2.conf
COPY ./apache/default/ /etc/apache2/sites-available

# Set workdir
WORKDIR "/var/www/html"

# Make it executable
RUN chmod +x /usr/local/bin/install-php-extensions\
# PHP extensions and composer using mlocati/docker-php-extension-installer
  && install-php-extensions xdebug pdo_mysql @composer\
# Set folder permissions
  && chown www-data:www-data . -R\
  && chmod 775 . -R\
# Install git, nodejs, postfix, curl and npm
  && apk update\
  && apk add git nodejs npm postfix curl\
  && npm install gulp -g\
  && npm install gulp --save-dev\
#   Configure xdebug
  && { \
    echo "xdebug.mode=debug,profile,trace"; \
    echo "xdebug.client_host=127.0.0.1"; \
    echo "xdebug.client_port=9003"; \
  } > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  

# Get latest wordpress
RUN curl -O https://wordpress.org/latest.tar.gz \
  && tar xvzf latest.tar.gz \
  && mv wordpress/* ./ \
  && rm ./latest.tar.gz && rm ./wordpress/ -R \
# Configure wordpress with ENV variables that should be passed in
# docker-compose file.
  && echo 'PassEnv WORDPRESS_DB_HOST' >> ./.htaccess \
  && echo 'PassEnv WORDPRESS_DB_NAME' >> ./.htaccess \
  && echo 'PassEnv WORDPRESS_DB_USER' >> ./.htaccess \
  && echo 'PassEnv WORDPRESS_DB_PASSWORD' >> ./.htaccess
# Default custom wp-config.
COPY ./wp-config.php /var/www/html/wp-config.php

# Run php interactively
# ENTRYPOINT ["docker-php-entrypoint"]
EXPOSE 80
EXPOSE 443
CMD ["php", "-a"]