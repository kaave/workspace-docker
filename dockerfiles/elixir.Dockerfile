FROM private:base
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile \
 && echo 'eval "$(anyenv init -)"' >> ~/.profile
RUN /bin/bash -lc 'anyenv install -s erlenv' \
 && /bin/bash -lc 'anyenv install -s exenv'

# Erlang 19.0
RUN curl -L http://www.erlang.org/download/otp_src_19.0.tar.gz -o /tmp/otp_src_19.0.tar.gz
RUN cd /tmp/ && tar xfvz otp_src_19.0.tar.gz
RUN cd /tmp/otp_src_19.0 \
 && export ERL_TOP=`pwd` \
 && ./configure --prefix=/home/kaave/.anyenv/envs/erlenv/releases/otp_src_19.0 \
 && make \
 && make install
RUN /bin/bash -lc 'erlenv global otp_src_19.0' \
 && /bin/bash -lc 'erlenv rehash'
RUN rm -rf /tmp/otp_src_19.0.tar.gz && rm -rf /tmp/otp_src_19.0

# Elixir 1.3.0
RUN /bin/bash -lc 'exenv install 1.3.0' \
 && /bin/bash -lc 'exenv global 1.3.0' \
 && /bin/bash -lc 'exenv rehash' \
 && /bin/bash -lc 'mix local.hex --force' \
 && /bin/bash -lc 'mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
