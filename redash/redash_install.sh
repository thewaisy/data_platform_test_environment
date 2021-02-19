#!/bin/bash

echo "********************"
echo "Deploying Redash"
echo "********************"

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl \
    pwgen \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    libssl-dev \
    webpack \
    build-essential

# docker 설치
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce
# usermod -aG docker $USER
usermod -aG docker root
systemctl enable docker

# docker-compose 설치
sudo curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# node 설치
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# /bin/bash -c ‘source ~/.bashrc’
chmod a+x ~/.bashrc
PS1='$ '
source ~/.bashrc

nvm install 12.18.4
nvm use 12.18.4
node -v
npm -version

# redash install

# 에러 해결[Error]System limit for number of file watchers reached
# https://velog.io/@yhe228/ErrorSystem-limit-for-number-of-file-watchers-reached
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "********************"
echo "install Redash"
echo "********************"

REDASH_BASE_PATH=/opt/redash

create_directories() {
    if [[ ! -e $REDASH_BASE_PATH ]]; then
        sudo mkdir -p $REDASH_BASE_PATH
        sudo chown $USER:$USER $REDASH_BASE_PATH
    fi

    if [[ ! -e $REDASH_BASE_PATH/postgres-data ]]; then
        mkdir $REDASH_BASE_PATH/postgres-data
    fi
}

create_config() {
    if [[ -e $REDASH_BASE_PATH/env ]]; then
        rm $REDASH_BASE_PATH/env
        touch $REDASH_BASE_PATH/env
    fi

    COOKIE_SECRET=$(pwgen -1s 32)
    SECRET_KEY=$(pwgen -1s 32)
    POSTGRES_PASSWORD=$(pwgen -1s 32)
    REDASH_DATABASE_URL="postgresql://postgres:${POSTGRES_PASSWORD}@postgres/postgres"

    echo "PYTHONUNBUFFERED=0" >> $REDASH_BASE_PATH/env
    echo "REDASH_LOG_LEVEL=INFO" >> $REDASH_BASE_PATH/env
    echo "REDASH_REDIS_URL=redis://redis:6379/0" >> $REDASH_BASE_PATH/env
    echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> $REDASH_BASE_PATH/env
    echo "REDASH_COOKIE_SECRET=$COOKIE_SECRET" >> $REDASH_BASE_PATH/env
    echo "REDASH_SECRET_KEY=$SECRET_KEY" >> $REDASH_BASE_PATH/env
    echo "REDASH_DATABASE_URL=$REDASH_DATABASE_URL" >> $REDASH_BASE_PATH/env

    echo "REDASH_MAIL_SERVER=localhost" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_PORT=25" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_USE_TLS=false" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_USE_SSL=false" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_USERNAME=None" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_PASSWORD=None" >> $REDASH_BASE_PATH/env
    echo "REDASH_MAIL_DEFAULT_SENDER=test@test.com" >> $REDASH_BASE_PATH/env

    echo "ATHENA_ANNOTATE_QUERY=false" >> $REDASH_BASE_PATH/env
}

setup_compose() {
    REQUESTED_CHANNEL=stable
    LATEST_VERSION=`curl -s "https://version.redash.io/api/releases?channel=$REQUESTED_CHANNEL"  | json_pp  | grep "docker_image" | head -n 1 | awk 'BEGIN{FS=":"}{print $3}' | awk 'BEGIN{FS="\""}{print $1}'`

    cd $REDASH_BASE_PATH
    GIT_BRANCH="${REDASH_BRANCH:-master}" # Default branch/version to master if not specified in REDASH_BRANCH env var
    wget https://raw.githubusercontent.com/getredash/setup/${GIT_BRANCH}/data/docker-compose.yml
    sed -ri "s/image: redash\/redash:([A-Za-z0-9.-]*)/image: redash\/redash:$LATEST_VERSION/" docker-compose.yml
    echo "export COMPOSE_PROJECT_NAME=redash" >> ~/.profile
    echo "export COMPOSE_FILE=/opt/redash/docker-compose.yml" >> ~/.profile
    export COMPOSE_PROJECT_NAME=redash
    export COMPOSE_FILE=/opt/redash/docker-compose.yml
    sudo docker-compose run --rm server create_db
    sudo docker-compose up -d
}

create_directories
create_config
setup_compose