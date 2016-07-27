FROM ubuntu:16.04
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

# define versions
ENV RUBY_VER 2.3.1
ENV NODE_VER v6.3.1
ENV ERLANG_VER 19.0
ENV ELIXIR_VER 1.3.2
ENV PYTHON2_VER 2.7.12
ENV PYTHON3_VER 3.5.2
ENV GOLANG_VER 1.6.3
ENV PHP_VER 7.0.9

# system update
RUN apt-get update -y && apt-get upgrade -y

# install some packages
RUN apt-get install -y apt-utils coreutils build-essential \
 && apt-get install -y unzip grep sudo bison libssl-dev openssl zlib1g-dev openssh-server \
 && apt-get install -y net-tools wget curl inetutils-ping inetutils-telnet inotify-tools \
 && apt-get install -y git mercurial gettext libncurses5-dev libperl-dev python-dev python3-dev ruby-dev lua5.2 liblua5.2-dev luajit libluajit-5.1 libbz2-dev \
 && apt-get install -y zsh tree tmux figlet htop direnv vim-gnome

# Haskell manager
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442 \
 && echo 'deb http://download.fpcomplete.com/ubuntu xenial main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

# japanese language
RUN apt-get install -y language-pack-ja-base language-pack-ja ibus-mozc man manpages-ja
RUN update-locale LANGUAGE=ja_JP.utf-8 LANG=ja_JP.utf-8
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8

# localtime
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# sshd
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir /var/run/sshd

# DB
RUN apt-get -y install sqlite3 libsqlite3-dev postgresql-client redis-tools mongodb-clients
# CAUTION: choose packages
# RUN apt-get -y install mysql-client
RUN apt-get -y install mariadb-client

# create user
RUN echo 'root:root' | chpasswd # set root's password: root
# create user & change user id & set sudo permit & set passwd
RUN useradd -m -u 501 kaave \
 && echo "kaave ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && echo 'kaave:kaave' | chpasswd # set kaave's password: kaave
RUN chsh -s /usr/bin/zsh kaave # set zsh

# ssh
# add kaave key
USER kaave
WORKDIR /home/kaave
ENV HOME /home/kaave
RUN mkdir .ssh
RUN chmod 700 .ssh
ADD id_rsa /home/kaave/.ssh/id_rsa
ADD id_rsa.pub /home/kaave/.ssh/id_rsa.pub
RUN cat .ssh/id_rsa.pub >> .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
USER root
WORKDIR /root
ENV HOME /root
RUN chown kaave /home/kaave/.ssh/id_rsa
RUN chown kaave /home/kaave/.ssh/id_rsa.pub
RUN chown kaave /home/kaave/.ssh/authorized_keys

# add root key (same file)
RUN mkdir .ssh
RUN chmod 700 .ssh
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub
RUN cat .ssh/id_rsa.pub >> .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown root /root/.ssh/id_rsa
RUN chown root /root/.ssh/id_rsa.pub
RUN chown root /root/.ssh/authorized_keys

USER kaave
WORKDIR /home/kaave
ENV HOME /home/kaave

# private settings
RUN git clone https://github.com/kaave/dotfiles.git ~/dotfiles \
 && git clone https://github.com/ali-inc/lint_configs.git ~/lint_configs \
 && git clone https://github.com/zsh-users/zsh-completions.git ~/zsh-completions
RUN ln -sf ~/lint_configs/.eslintrc ~/.eslintrc \
 && ln -sf ~/lint_configs/.scss-lint.yml ~/.scss-lint.yml

# dotfiles setup
RUN /bin/bash ~/dotfiles/_setup.bash

# append watch files count
RUN echo "echo 524288 | sudo tee -a /proc/sys/fs/inotify/max_user_watches" >> ~/.zshrcextra

# create sync dir.
RUN mkdir ~/work

# anyenv
RUN git clone https://github.com/riywo/anyenv.git ~/.anyenv \
 && git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update \
 && git clone https://github.com/znz/anyenv-git.git ~/.anyenv/plugins/anyenv-git

# ruby
RUN /bin/bash -lc 'anyenv install -s rbenv'
RUN git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.anyenv/envs/rbenv/plugins/rbenv-default-gems \
 && git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.anyenv/envs/rbenv/plugins/rbenv-gem-rehash
RUN ln -sf ~/dotfiles/default_libraries/default-gems ~/.anyenv/envs/rbenv/default-gems
RUN /bin/bash -lc "rbenv install $RUBY_VER" \
 && /bin/bash -lc "rbenv global $RUBY_VER"

# Node.js
RUN /bin/bash -lc 'anyenv install -s ndenv'
RUN git clone https://github.com/kaave/ndenv-default-npms.git ~/.anyenv/envs/ndenv/plugins/ndenv-default-npms
RUN ln -sf ~/dotfiles/default_libraries/default-npms ~/.anyenv/envs/ndenv/default-npms
RUN /bin/bash -lc "ndenv install $NODE_VER" \
 && /bin/bash -lc "ndenv global $NODE_VER" \
 && /bin/bash -lc 'ndenv rehash'

# Erlang
RUN /bin/bash -lc 'anyenv install -s erlenv'
RUN curl -L http://www.erlang.org/download/otp_src_$ERLANG_VER.tar.gz -o /tmp/otp_src_$ERLANG_VER.tar.gz
RUN cd /tmp/ && tar xfvz otp_src_$ERLANG_VER.tar.gz
RUN cd /tmp/otp_src_$ERLANG_VER \
 && export ERL_TOP=`pwd` \
 && ./configure --prefix=/home/kaave/.anyenv/envs/erlenv/releases/otp_src_$ERLANG_VER \
 && make \
 && make install
RUN /bin/bash -lc "erlenv global otp_src_$ERLANG_VER" \
 && /bin/bash -lc 'erlenv rehash'
RUN rm -rf /tmp/otp_src_$ERLANG_VER.tar.gz && rm -rf /tmp/otp_src_$ERLANG_VER

# Elixir
RUN /bin/bash -lc 'anyenv install -s exenv'
RUN /bin/bash -lc "exenv install $ELIXIR_VER" \
 && /bin/bash -lc "exenv global $ELIXIR_VER" \
 && /bin/bash -lc 'exenv rehash' \
 && /bin/bash -lc 'mix local.hex --force' \
 && /bin/bash -lc 'mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force'

# Python
RUN /bin/bash -lc 'anyenv install -s pyenv'
RUN git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.anyenv/envs/ndenv/plugins/pyenv-virtualenv \
 && /bin/bash -lc "pyenv install $PYTHON2_VER" \
 && /bin/bash -lc "pyenv install $PYTHON3_VER" \
 && /bin/bash -lc "pyenv global $PYTHON2_VER" \
 && /bin/bash -lc 'pyenv rehash'

# go
RUN /bin/bash -lc 'anyenv install -s goenv'
RUN /bin/bash -lc "goenv install $GOLANG_VER" \
 && /bin/bash -lc "goenv global $GOLANG_VER" \
 && /bin/bash -lc 'goenv rehash'

# PHP
RUN /bin/bash -lc 'anyenv install -s phpenv'
RUN sudo apt-get install -y libxml2-dev re2c imagemagick libcurl4-openssl-dev libjpeg-dev libpng-dev libmcrypt-dev libtidy-dev libxslt-dev autoconf automake
RUN /bin/bash -lc "phpenv install $PHP_VER" \
 && /bin/bash -lc "phpenv global $PHP_VER" \
 && /bin/bash -lc 'phpenv rehash'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

