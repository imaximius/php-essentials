FROM php:7.2-fpm

MAINTAINER Maksym Churkin <imaximius@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://httpredir.debian.org/debian jessie contrib' >> /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    git \
    unzip \
    librabbitmq-dev \
    gnupg

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD https://phar.phpunit.de/phpunit.phar  /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpcpd.phar   /usr/local/bin/phpcpd
ADD https://phar.phpunit.de/phpdcd.phar   /usr/local/bin/phpdcd
ADD https://phar.phpunit.de/phploc.phar   /usr/local/bin/phploc
#ADD https://github.com/sensiolabs-de/deprecation-detector/releases/download/0.1.0-alpha4/deprecation-detector.phar /usr/local/bin/deprecation-detector

# Make the tools executable
RUN cd /usr/local/bin && \
    chmod +x composer phpunit phpcpd phpdcd phploc

#deprecation-detector

RUN /usr/local/bin/composer global require \
	'squizlabs/php_codesniffer=3.4.*' \
	'pdepend/pdepend=2.5.*' \
	'sensiolabs-de/deprecation-detector=0.1.*@dev'

# Install AMPQ ext
RUN pecl install amqp \
    && docker-php-ext-enable amqp

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt install -y npm

RUN npm install -g swagger

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

CMD ["/usr/bin/php" , "-a"]
