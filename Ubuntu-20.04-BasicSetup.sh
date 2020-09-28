#!/bin/bash

sudo apt update && sudo apt upgrade -y

# Install basic packages
sudo apt -y install \
  software-properties-common \
  build-essential \
  zip unzip \
  make \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  python-openssl \
  git \
  direnv \
  jq

install_python3_pip() {
  sudo apt install -y python3-pip
}

install_miniconda() {
  mkdir -p ~/miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
  rm -rf ~/miniconda3/miniconda.sh
  ~/miniconda3/bin/conda init bash
  ~/miniconda3/bin/conda config --set auto_activate_base false
}

install_python_conda_packages() {
  ~/miniconda3/bin/conda install -y -c conda-forge \
    jupyterlab \
    notebook \
    voila \
    pandas \
    ipython
}

install_php7() {
  sudo apt install -y \
    openssl \
    php-pear \
    php-cli \
    php7.4 \
    php7.4-{common,bz2,imap,intl,bcmath,json,mbstring,soap,sybase,xsl,zip}
}

install_composer() {
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  HASH=`curl -sS https://composer.github.io/installer.sig`
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  
  rm -f composer-setup.php
}

install_nvm() {
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  command -v nvm
}

export_nvm_dir() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

install_nodejs_12_lts() {
  export_nvm_dir
  nvm install v12
}

install_yarn() {
  npm i -g yarn
  yarn --version
}

install_java_jre() {
  sudo apt install -y default-jre
  java -version
}

install_java_jdk() {
  sudo apt install -y default-jdk
  javac -version

  echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.bashrc
  source ~/.bashrc
}

export_sdkman_init() {
  source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_sdkman() {
  curl -s "https://get.sdkman.io" | bash
  export_sdkman_init
  sdk version
}

install_gradle() {
  export_sdkman_init

  sdk install gradle
  gradle --version
}

install_dotnet_sdk() {
  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb

  sudo apt-get update; \
    sudo apt-get install -y apt-transport-https && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-3.1

  rm -f packages-microsoft-prod.deb
}

install_dotnet_runtime() {
  sudo apt-get install -y dotnet-runtime-3.1
}

setup_direnv_bash() {
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
}

mkdir -p Ubuntu-20.04-BasicSetup

echo "Installing Miniconda3 Package Tool..."
install_miniconda > Ubuntu-20.04-BasicSetup/miniconda_install.log

echo "Installing Python Common Packages..."
install_python_conda_packages > Ubuntu-20.04-BasicSetup/python_conda_packages_install.log

echo "Installing PHP 7..."
install_php7 > Ubuntu-20.04-BasicSetup/php7_install.log

echo "Installing Composer Package Tool..."
install_composer > Ubuntu-20.04-BasicSetup/composer_install.log

echo "Installing NVM (NodeJS Version Manager)..."
install_nvm > Ubuntu-20.04-BasicSetup/nvm_install.log

echo "Installing NodeJS v12 LTS..."
install_nodejs_12_lts > Ubuntu-20.04-BasicSetup/nodejs12_lts_install.log

echo "Installing Yarn..."
install_yarn > Ubuntu-20.04-BasicSetup/yarn_install.log

echo "Installing Java JRE..."
install_java_jre > Ubuntu-20.04-BasicSetup/java_jre_install.log

echo "Installing Java JDK..."
install_java_jdk > Ubuntu-20.04-BasicSetup/java_jdk_install.log

echo "Installing SDKMAN..."
install_sdkman > Ubuntu-20.04-BasicSetup/sdkman_install.log

echo "Installing Gradle..."
install_gradle > Ubuntu-20.04-BasicSetup/gradle_install.log

echo "Installing .NET Core 3.1 SDK..."
install_dotnet_sdk > Ubuntu-20.04-BasicSetup/dotnet_sdk_install.log

echo "Installing .NET Core 3.1 Runtime..."
install_dotnet_runtime > Ubuntu-20.04-BasicSetup/dotnet_runtime_install.log

echo "Setup direnv..."
setup_direnv_bash
