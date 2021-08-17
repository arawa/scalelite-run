#!bin/bash

# ##################################################
# NGINX_HOSTNAME=
# URL_HOST=

# #/***** SCALELITE SPECIFIC ******/#
# SECRET_KEY_BASE=
# LOADBALANCER_SECRET=
# SCALELITE_TAG=v1.1.6
# WEB_CONCURRENCY=8
# POLLER_THREADS=20
# SCALELITE_DOCKER_IMAGE=blindsidenetwks/scalelite:v1.1.6
# RECORDING_DISABLED=true
# SERVER_ID_IS_HOSTNAME=true
# DOCKER_PROXY_NGINX_TEMPLATE=scalelite-proxy
# #####################################################

echo "#/***** General ******/#" > .env
echo -e "\e[36mHost URL : (ex: bbb-scalelite.arawa.fr)\e[39m"
read SH_HOSTNAME
echo NGINX_HOSTNAME=$SH_HOSTNAME >> .env
echo URL_HOST=$SH_HOSTNAME >> .env

printf "\n" >> .env
echo "#/***** SCALELITE SPECIFIC ******/#" >> .env
SECRET_KEY_BASE=$(openssl rand -hex 64)
LOADBALANCER_SECRET=$(openssl rand -hex 32)
echo SECRET_KEY_BASE=$SECRET_KEY_BASE >> .env
echo LOADBALANCER_SECRET=$LOADBALANCER_SECRET >> .env

echo -e "\e[36mScalelite tag version (default: 1.1.6) :\e[39m"
read SCALELITE_TAG
if [[ -z $SCALELITE_TAG ]]; then
  SCALELITE_TAG="1.1.6"
fi
echo SCALELITE_TAG=v$SCALELITE_TAG >> .env

echo -e "\e[36mWEB_CONCURRENCY (default: 8) :\e[39m"
read WEB_CONCURRENCY
if [[ -z "$WEB_CONCURRENCY" ]]; then
  WEB_CONCURRENCY=8
fi
echo WEB_CONCURRENCY=$WEB_CONCURRENCY >> .env

echo -e "\e[36mPOLLER_THREADS (default: 20) :\e[39m"
read POLLER_THREADS
if [[ -z "$POLLER_THREADS" ]]; then
  POLLER_THREADS=20
fi
echo POLLER_THREADS=$POLLER_THREADS >> .env

echo SERVER_ID_IS_HOSTNAME=true >> .env

echo -e "\e[36mEnable recording feature ? (Y/n) :\e[39m"
read RECORDING_DISABLED
if [[ "$RECORDING_DISABLED" == "Y" ]] || [[ "$RECORDING_DISABLED" == "y" ]]|| [[ -z "$RECORDING_DISABLED" ]]; then
  RECORDING_DISABLED=false
else
  RECORDING_DISABLED=true
fi
echo RECORDING_DISABLED=$RECORDING_DISABLED >> .env

printf "\n" >> .env
echo "#/***** DOCKER ******/#" >> .env

echo SCALELITE_DOCKER_IMAGE=blindsidenetwks/scalelite:v$SCALELITE_TAG >> .env

if [[ "$RECORDING_DISABLED" == true ]]; then
  DOCKER_PROXY_NGINX_TEMPLATE=scalelite-proxy
else
  DOCKER_PROXY_NGINX_TEMPLATE=scalelite-recording
fi
echo DOCKER_PROXY_NGINX_TEMPLATE=$DOCKER_PROXY_NGINX_TEMPLATE >> .env

echo SCALELITE_RECORDING_DIR=/mnt/scalelite-recordings/var/bigbluebutton/ >> .env

printf "\n" >> .env
echo "#/***** Certbot ******/#" >> .env

echo LETSENCRYPT_EMAIL=tech@arawa.fr >> .env

echo -e "\e[32m.env generation done for \e[93m$SH_HOSTNAME \e[32m! \e[39m"
echo -e "\e[32m####################################### \e[39m"
echo -e "\e[32mSecret key : \e[93m$SECRET_KEY_BASE \e[39m"
echo -e "\e[32mLoad balancer key : \e[93m$LOADBALANCER_SECRET \e[39m"
echo -e "\e[32m####################################### \e[39m"