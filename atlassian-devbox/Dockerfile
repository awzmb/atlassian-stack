FROM docker.io/fedora:latest

ARG CODE_RELEASE=4.14.0

# update packages
RUN dnf -y update

# enable rpmfusion repositories
RUN rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
RUN rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y install \
  zsh vim neovim vifm util-linux-user calc \
  unrar exa bat jq jd tree ack git fd-find fzf sqlite \
  libgpiod-utils python3-libgpiod netcat

# openvpn connections via nmcli
RUN dnf -y install \
  NetworkManager-openvpn

# python environment
RUN dnf -y install \
  pipenv \
  python3-autopep8 \
  python3-pandas \
  python3-pip \
  yamllint

# java dev environment
RUN dnf -y install \
  java-11-openjdk \
  maven

# code-server
RUN dnf -y install \
  libatomic \
  nano

RUN echo "**** install code-server ****" && \
  if [ -z ${CODE_RELEASE+x} ]; then \
    CODE_RELEASE=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||'); \
  fi && \
  mkdir -p /app/code-server && \
  curl -o \
    /tmp/code-server.tar.gz -L \
    "https://github.com/coder/code-server/releases/download/v${CODE_RELEASE}/code-server-${CODE_RELEASE}-linux-amd64.tar.gz" && \
  tar xf /tmp/code-server.tar.gz -C \
    /app/code-server --strip-components=1

# terminal tools and software
RUN dnf -y install \
  w3m \
  w3m-img \
  python3-neovim \
  calcurse

# install vim-plug plugin manager
# for vim and neovim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# aws tools
RUN dnf -y install \
  aws-tools \
  awscli

# openvpn
RUN dnf -y install \
  openvpn

# helm kubernetes package manager
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
  sh get_helm.sh && \
  rm get_helm.sh

# vim dependencies
RUN dnf -y install \
  yarnpkg

# cleanup
RUN dnf clean all

# copy over files from linuxserver/code-server
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
