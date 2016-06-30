FROM private:base
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile \
 && echo 'eval "$(anyenv init -)"' >> ~/.profile
RUN /bin/bash -lc 'anyenv install -s phpenv'

# PHP 7.0.7
# i don't write PHP
RUN sudo apt-get install -y libxml2-dev re2c imagemagick libcurl4-openssl-dev libjpeg-dev libpng-dev libmcrypt-dev libtidy-dev libxslt-dev autoconf automake
RUN /bin/bash -lc 'phpenv install 7.0.7' \
 && /bin/bash -lc 'phpenv global 7.0.7' \
 && /bin/bash -lc 'phpenv rehash'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
