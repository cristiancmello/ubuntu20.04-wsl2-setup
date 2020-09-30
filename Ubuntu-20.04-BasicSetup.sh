#!/bin/bash

CONDA_BIN=~/miniconda3/condabin/conda
INSTALLATION_LOG_DIR=logs

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
  if [ ! -f "$CONDA_BIN" ]; then
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda config --set auto_activate_base false
  fi
}

install_python_conda_packages() {
  eval "${CONDA_BIN} install -y -c conda-forge jupyterlab notebook voila pandas ipython"
}

install_php7() {
  sudo apt install -y \
    openssl \
    php-pear \
    php7.4 \
    php7.4-{dev,cli,bcmath,common,bz2,imap,intl,json,mbstring,soap,sybase,xsl,zip,mysql,sqlite3}
}

install_composer() {
  if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    HASH=`curl -sS https://composer.github.io/installer.sig`
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    
    rm -f composer-setup.php
    export_composer_binpaths
  fi
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

export_composer_binpaths() {
  echo 'export PATH=$PATH:~/.config/composer/vendor/bin' >> ~/.bashrc
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
  DOTNET_BIN=/usr/bin/dotnet

  if [ ! -f "$DOTNET_BIN" ]; then
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb

    sudo apt-get update; \
      sudo apt-get install -y apt-transport-https && \
      sudo apt-get update && \
      sudo apt-get install -y dotnet-sdk-3.1

    rm -f packages-microsoft-prod.deb
  fi
}

install_dotnet_runtime() {
  sudo apt-get install -y dotnet-runtime-3.1
}

install_geckodriver() {
  GECKODRIVER_VERSION=0.27.0
  GECKODRIVER_OS_ARCH=linux64
  GECKODRIVER_TAR_FILENAME="geckodriver-v${GECKODRIVER_VERSION}-${GECKODRIVER_OS_ARCH}.tar.gz"
  GECKODRIVER_BIN_FILENAME=geckodriver
  GH_URL="https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/$GECKODRIVER_TAR_FILENAME"

  if [[ -z `which $GECKODRIVER_BIN_FILENAME` ]]; then
    wget "$GH_URL"
    tar -xvf "$GECKODRIVER_TAR_FILENAME"
    sudo mv "$GECKODRIVER_BIN_FILENAME" /usr/local/bin/
    rm -f "$GECKODRIVER_TAR_FILENAME"
  else
    echo "Mozilla Geckodriver already installed."
  fi
}

setup_direnv_bash() {
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
}

apt_autoremove() {
  sudo apt autoremove
}

xserver_envs() {
cat << EOF >> ~/.bashrc
export DISPLAY=\$(awk '/nameserver / {print \$2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1
EOF
}

mkdir -p "$INSTALLATION_LOG_DIR"

echo "Installing Miniconda3 Package Tool..."
install_miniconda > "$INSTALLATION_LOG_DIR/miniconda_install.log"

echo "Installing Python Common Packages..."
install_python_conda_packages > "$INSTALLATION_LOG_DIR/python_conda_packages_install.log"

echo "Installing PHP 7..."
install_php7 > "$INSTALLATION_LOG_DIR/php7_install.log"

echo "Installing Composer Package Tool..."
install_composer > "$INSTALLATION_LOG_DIR/composer_install.log"

echo "Installing NVM (NodeJS Version Manager)..."
install_nvm > "$INSTALLATION_LOG_DIR/nvm_install.log"

echo "Installing NodeJS v12 LTS..."
install_nodejs_12_lts > "$INSTALLATION_LOG_DIR/nodejs12_lts_install.log"

echo "Installing Yarn..."
install_yarn > "$INSTALLATION_LOG_DIR/yarn_install.log"

echo "Installing Java JRE..."
install_java_jre > "$INSTALLATION_LOG_DIR/java_jre_install.log"

echo "Installing Java JDK..."
install_java_jdk > "$INSTALLATION_LOG_DIR/java_jdk_install.log"

echo "Installing SDKMAN..."
install_sdkman > "$INSTALLATION_LOG_DIR/sdkman_install.log"

echo "Installing Gradle..."
install_gradle > "$INSTALLATION_LOG_DIR/gradle_install.log"

echo "Installing .NET Core 3.1 SDK..."
install_dotnet_sdk > "$INSTALLATION_LOG_DIR/dotnet_sdk_install.log"

echo "Installing .NET Core 3.1 Runtime..."
install_dotnet_runtime > "$INSTALLATION_LOG_DIR/dotnet_runtime_install.log"

echo "Installing Mozilla Geckodriver..."
install_geckodriver > "$INSTALLATION_LOG_DIR/geckodriver_install.log"

echo "APT Autoremove..."
apt_autoremove > "$INSTALLATION_LOG_DIR/apt_autoremove.log"

echo "Setup direnv..."
setup_direnv_bash

echo "Setup X server variables"
xserver_envs
