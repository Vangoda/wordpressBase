# WordpressBase

> ! Current dockerfile is not the one this image is based on !

Template repository for newest wordpress empty wordpress instalation.

Docker-compose is setup with ENV variables for security. Be sure to edit the attached .env file and set your passwords. Provided  .gitignore file contains the .env entry in it to avoid uploading your secrets to github(or similiar).

XDebug is installed, but it is disabled by default as it consumes huge amounts of ram and slows  down the application noticabely(up to 10 times faster with  xdebug off).    It can be turned on by editing the *docker-php-ext-xdebug.ini* in the *config-custom* folder, just uncommment everything for default setup.

This is intended to be used with nginx-proxy with SSL, wordpress is setup to use it. If you don't have your own image for nginx-proxy you can use this one [vangoda/nginx-proxy-auto:1.2-alpine](https://hub.docker.com/layers/vangoda/nginx-proxy-auto/1.2-alpine/images/sha256-cb5c36ce61973b78255692fce4c2e1044ccf7a1c61299a03d5b700f7b5a18adc?context=repo).

**Remember to generate domain certificate or SSL won't work!**
