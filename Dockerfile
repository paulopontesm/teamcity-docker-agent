FROM jetbrains/teamcity-minimal-agent:latest

MAINTAINER Rodrigo Fernandes <rodrigo@codacy.com>

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV RUBY_VERSION 2.3.1
ENV NODE_VERSION 7.4.0

ENV RBENV_HOME "/root/.rbenv"
ENV NODENV_HOME "/root/.nodenv"
ENV COMPOSER_HOME "/root/.composer"

ENV PATH "$RBENV_HOME/bin:$RBENV_HOME/shims:$NODENV_HOME/bin:$NODENV_HOME/shims:$COMPOSER_HOME/bin:$PATH"

RUN \
    groupadd -g 2004 docker && \
    adduser --disabled-password --gecos "" --uid 2004 --gid 2004 docker && \
    gpasswd -a docker docker && \
    gpasswd -a root docker

RUN apt-get update -y && \
    apt-get install -y software-properties-common zip mercurial apt-transport-https ca-certificates && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    add-apt-repository ppa:ondrej/php && \
    add-apt-repository ppa:git-core/ppa && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update -y && \
    apt-get install -y git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev && \
    \
    apt-get -y install oracle-java8-installer && \
    apt-get -y install oracle-java8-unlimited-jce-policy && \
    apt-get -y install oracle-java8-set-default && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    git config --global core.quotepath false && \
    git config --global core.packedGitLimit 512m && \
    git config --global core.packedGitWindowSize 512m && \
    git config --global pack.deltaCacheSize 2047m && \
    git config --global pack.packSizeLimit 2047m && \
    git config --global pack.windowMemory 2047m && \
    apt-get -y install apparmor libdevmapper1.02.1 && \
    ln -sf /lib/x86_64-linux-gnu/libdevmapper.so.1.02.1 /lib/x86_64-linux-gnu/libdevmapper.so.1.02 && \
    apt-get install -y python python-dev python-pip libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev && \
    python -m pip install --upgrade pip && \
    python -m pip install --upgrade awscli && \
    python -m pip install --upgrade ansible && \
    python -m pip install --upgrade boto && \
    python -m pip install --upgrade tox && \
    python -m pip install --upgrade docker-compose && \
    python -m pip install --upgrade metrics===0.2.6 && \
    python -m pip install --upgrade radon===1.4.2 && \
    \
    apt-get install -y sbt && \
    \
    apt-get install -y php5-dev php5-cli && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /bin/composer && \
    composer global require "pdepend/pdepend=2.4.1" && \
    \
    git clone https://github.com/rbenv/rbenv.git $RBENV_HOME && \
    git clone https://github.com/rbenv/ruby-build.git $RBENV_HOME/plugins/ruby-build && \
    eval "$(rbenv init -)" && \
    rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc && \
    gem install bundler && \
    gem install sass && \
    \
    git clone https://github.com/nodenv/nodenv.git $NODENV_HOME && \
    git clone https://github.com/nodenv/node-build.git $NODENV_HOME/plugins/node-build && \
    eval "$(nodenv init -)" && \
    nodenv install -s $NODE_VERSION && \
    nodenv global $NODE_VERSION && \
    echo 'eval "$(nodenv init -)"' >> /root/.bashrc && \
    npm install -g cloc@2.2.0 && \
    \
    apt-get clean all
