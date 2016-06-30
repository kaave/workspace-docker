FROM private:base
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

RUN /bin/bash -lc 'anyenv install -s pyenv'

# Python 2.7.11 & 3.5.1
RUN git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.anyenv/envs/ndenv/plugins/pyenv-virtualenv \
 && /bin/bash -lc 'pyenv install 2.7.11' \
 && /bin/bash -lc 'pyenv install 3.5.1' \
 && /bin/bash -lc 'pyenv global 2.7.11' \
 && /bin/bash -lc 'pyenv rehash'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
