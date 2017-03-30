FROM php:7.1-fpm

MAINTAINER Maksym Churkin <m.churkyn@globalgames.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    git \
    unzip

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD https://phar.phpunit.de/phpunit.phar  /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpcpd.phar   /usr/local/bin/phpcpd
ADD https://phar.phpunit.de/phpdcd.phar   /usr/local/bin/phpdcd
ADD https://phar.phpunit.de/phploc.phar   /usr/local/bin/phploc
ADD https://github.com/sensiolabs-de/deprecation-detector/releases/download/0.1.0-alpha4/deprecation-detector.phar /usr/local/bin/deprecation-detector


# Make the tools executable
RUN cd /usr/local/bin && \
  chmod +x composer phpunit phpcpd phpdcd phploc deprecation-detector

RUN /usr/local/bin/composer global require \
	'squizlabs/php_codesniffer=1.5.*' \
	'pdepend/pdepend=1.1.*' \
	'phpmd/phpmd=1.4.*' \
	'behat/behat=2.4.*@stable'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

CMD ["/usr/bin/php" , "-a"]
