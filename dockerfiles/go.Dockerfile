FROM private:base
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile \
 && echo 'eval "$(anyenv init -)"' >> ~/.profile
RUN /bin/bash -lc 'anyenv install -s goenv'

# go 1.6.2
# i don't write go
RUN /bin/bash -lc 'goenv install 1.6.2' \
 && /bin/bash -lc 'goenv global 1.6.2' \
 && /bin/bash -lc 'goenv rehash'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
