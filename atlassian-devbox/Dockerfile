FROM docker.io/alpine:edge

ARG CODE_RELEASE=4.14.0

# update list and packages
RUN apk update && apk upgrade

# core functionality
RUN apk add \
  util-linux pciutils usbutils coreutils binutils findutils grep iproute2 git

# basic packages
RUN apk add \
  vim zsh bash neovim tmux pass \
  openssl curl bat w3m exa zip \
  ctags zsh-vcs python3 ack p7zip \
  coreutils tree ranger nodejs \
  npm yarn curl wget fd fzf openssh \
  nodejs grep tar openssl \
  ca-certificates ncurses ruby \
  gcompat libuser bash bash-doc \
  bash-completion shadow

# devops tools
RUN apk add \
  terraform ansible aws-cli py3-pip
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  terragrunt

# go development
RUN apk add go

# openvpn
RUN apk add openvpn

# java development
RUN apk add \
  openjdk17-jdk \
  openjdk11-jdk \
  openjdk8 \
  maven

# building and c
RUN apk add \
  build-base gcc abuild binutils binutils-doc gcc-doc

# python packages
RUN pip install \
  markdown \
  html2text \
  requests \
  beautifulsoup4 \
  pyyaml \
  pyxdg \
  pytz \
  python-dateutil \
  urwid

# terraform-docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz && \
  tar -xzf terraform-docs.tar.gz && \
  rm terraform-docs.tar.gz && \
  chmod +x terraform-docs && \
  mv terraform-docs /usr/local/bin/terraform-docs

# infracost
RUN curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# download kubectl binary
#RUN wget "https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl" -O "/usr/local/bin/kubectl"
RUN curl -o /usr/local/bin/kubectl \
  -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

RUN echo "**** install code-server ****" && \
  if [ -z ${CODE_RELEASE+x} ]; then \
    CODE_RELEASE=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||'); \
  fi && \
  mkdir -p /app/code-server && \
  curl -o /tmp/code-server.tar.gz \
    -L "https://github.com/coder/code-server/releases/download/v${CODE_RELEASE}/code-server-${CODE_RELEASE}-linux-amd64.tar.gz" && \
  tar xf /tmp/code-server.tar.gz -C \
    /app/code-server --strip-components=1

# install vim-plug plugin manager
# for vim and neovim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install atlassian sdk and set ATLAS_HOME accordingly
RUN curl -o /tmp/atlassian-plugin-sdk.tar.gz -L "https://marketplace.atlassian.com/download/plugins/atlassian-plugin-sdk-tgz" && \
  mkdir -p /app/atlassian-sdk && \
  tar xf /tmp/atlassian-plugin-sdk.tar.gz -C \
    /app/atlassian-sdk --strip-components=1
RUN echo "export ATLAS_HOME=/app/atlassian-sdk" > /etc/profile.d/atlassian-sdk.sh

# maven settings.xml for atlassian development
RUN mkdir -p ${HOME}/.m2
ADD ./maven-settings.xml ${HOME}/.m2/settings.xml

# helm kubernetes package manager
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
  sh get_helm.sh && \
  rm get_helm.sh

# get custom shell setup from github
RUN git clone https://github.com/awzmb/wmconfig $HOME/.cfg
RUN $HOME/.cfg/install || :

# set default shell to zsh
RUN chsh -s /bin/zsh && \
  echo "export SHELL=/bin/zsh" > /etc/profile.d/40zshdefaultshell.sh

# set default jvm/jdk to openjdk11 and set JAVA_HOME to default-jvm directory
RUN rm -rf /usr/lib/jvm/default-jvm && \
  ln -s /usr/lib/jvm/java-11-openjdk /usr/lib/jvm/default-jvm && \
  echo "export JAVA_HOME=/usr/lib/jvm/default-jvm" > /etc/profile.d/jdk.sh

# copy over files from linuxserver/code-server
ADD ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "bash", "/app/entrypoint.sh" ]
