FROM private:base
MAINTAINER kaave junkjunctions@gmail.com

# anti error message
ENV DEBIAN_FRONTEND noninteractive

RUN /bin/bash -lc 'anyenv install -s rbenv'

# ruby 2.3.1
RUN git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.anyenv/envs/rbenv/plugins/rbenv-default-gems \
 && git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.anyenv/envs/rbenv/plugins/rbenv-gem-rehash
RUN ln -sf ~/dotfiles/default-gems ~/.anyenv/envs/ndenv/default-gems
RUN /bin/bash -lc 'rbenv install 2.3.1' \
 && /bin/bash -lc 'rbenv global 2.3.1'

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
