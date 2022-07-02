# Base PHP FPM image for development
FROM vangoda/php-fpm-alpine

WORKDIR /var/www/html

# # Enable ENV variables in PHP for wordpress config
# USER root
# RUN sed -i 's/[;clear_env = no]/[clear_env = no]/' /usr/local/etc/php-fpm.d/www.conf \
#   && echo -e "\nenv[WORDPRESS_DB_HOST] = $WORDPRESS_DB_HOST" >> /usr/local/etc/php-fpm.d/www.conf \
#   && echo -e "\nenv[WORDPRESS_DB_NAME] = $WORDPRESS_DB_NAME" >> /usr/local/etc/php-fpm.d/www.conf \
#   && echo -e "\nenv[WORDPRESS_DB_USER] = $WORDPRESS_DB_USER" >> /usr/local/etc/php-fpm.d/www.conf \
#   && echo -e "\nenv[WORDPRESS_DB_PASSWORD] = $WORDPRESS_DB_PASSWORD" >> /usr/local/etc/php-fpm.d/www.conf

# # Install latest wordpress
USER www-data
RUN curl -O https://wordpress.org/latest.tar.gz \
  && tar xvzf latest.tar.gz \
  && mv wordpress/* ./ \
  && rm ./latest.tar.gz && rm ./wordpress/ -R

# Install wordpress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar

# Configure wordpress
COPY ./wp-config.php ./wp-config.php
USER root
RUN chown www-data:www-data wp-config.php

# Generate WP salts via WP CLI
USER www-data
RUN php wp-cli.phar config shuffle-salts