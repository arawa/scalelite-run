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
# DOCKER_PROXY_NGINX_TEMPLATE=scalelite-proxy-protected
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

echo -e "\e[36mScalelite tag version (default: 1.3.2) :\e[39m"
read SCALELITE_TAG
if [[ -z $SCALELITE_TAG ]]; then
  SCALELITE_TAG="1.3.2"
fi

printf "\n" >> .env
echo "# Number of threads for the Puma Web server to launch at startup" >> .env
echo -e "\e[36mWEB_CONCURRENCY (default: 8) :\e[39m"
read WEB_CONCURRENCY
if [[ -z "$WEB_CONCURRENCY" ]]; then
  WEB_CONCURRENCY=8
fi
echo WEB_CONCURRENCY=$WEB_CONCURRENCY >> .env

printf "\n" >> .env
echo "# Number of poller concurrent threads" >> .env
echo "# Raising POLLER_THREADS can lead to DNS Denials Of Service" >> .env
echo -e "\e[36mPOLLER_THREADS (default: 10) :\e[39m"
read POLLER_THREADS
if [[ -z "$POLLER_THREADS" ]]; then
  POLLER_THREADS=10
fi
echo POLLER_THREADS=$POLLER_THREADS >> .env

printf "\n" >> .env
echo "# Interval between two poller runs" >> .env
echo -e "\e[36mPOLL_INTERVAL (default: 60) :\e[39m"
read POLL_INTERVAL
if [[ -z "$POLL_INTERVAL" ]]; then
  POLL_INTERVAL=60
fi
echo POLL_INTERVAL=$POLL_INTERVAL >> .env

printf "\n" >> .env
echo "# Timeout for the entire poller run to complete" >> .env
echo -e "\e[36mPOLLER_WAIT_TIMEOUT (default: 100) :\e[39m"
read POLLER_WAIT_TIMEOUT
if [[ -z "$POLLER_WAIT_TIMEOUT" ]]; then
  POLLER_WAIT_TIMEOUT=100
fi
echo POLLER_WAIT_TIMEOUT=$POLLER_WAIT_TIMEOUT >> .env

printf "\n" >> .env
echo "# Timeout (in seconds) for establishing a connection to BBB servers" >> .env
echo "# Reduce CONNECT_TIMEOUT to 2 (seconds) so that polling goes faster (POLLER_THREADS servers every max CONNECT_TIMEOUT seconds)" >> .env
echo "# For example : For 150 servers, 10 every max 2 seconds : 30 seconds MAX" >> .env
echo -e "\e[36mCONNECT_TIMEOUT (default: 2) :\e[39m"
read CONNECT_TIMEOUT
if [[ -z "$CONNECT_TIMEOUT" ]]; then
  CONNECT_TIMEOUT=20
fi
echo CONNECT_TIMEOUT=$CONNECT_TIMEOUT >> .env

printf "\n" >> .env
echo "# Timeout (in seconds) for getting a response from BBB server API" >> .env
echo -e "\e[36mRESPONSE_TIMEOUT (default: 10) :\e[39m"
read RESPONSE_TIMEOUT
if [[ -z "$RESPONSE_TIMEOUT" ]]; then
  RESPONSE_TIMEOUT=10
fi
echo CONNECT_TIMEOUT=$CONNECT_TIMEOUT >> .env

printf "\n" >> .env
echo "# Number of times a server is detected as unresponsive before panicking it and tagging it ''offline''" >> .env
echo -e "\e[36mSERVER_UNHEALTHY_THRESHOLD (default: 2) :\e[39m"
read SERVER_UNHEALTHY_THRESHOLD
if [[ -z "$SERVER_UNHEALTHY_THRESHOLD" ]]; then
  SERVER_UNHEALTHY_THRESHOLD=10
fi
echo SERVER_UNHEALTHY_THRESHOLD=$SERVER_UNHEALTHY_THRESHOLD >> .env

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
  DOCKER_PROXY_NGINX_TEMPLATE=scalelite-proxy-protected
else
  #DOCKER_PROXY_NGINX_TEMPLATE=scalelite-recording
  DOCKER_PROXY_NGINX_TEMPLATE=scalelite-proxy-protected
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
