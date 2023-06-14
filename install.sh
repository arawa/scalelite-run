#!bin/bash

# Custom certs
printf "\n"
echo -e "\e[33mBefore running this script, please put if needed the custom certs to the arawa dir :\e[39m"
echo -e "\e[33mcp {fullchain.pem,privkey.pem} data/arawa/cert/\e[39m"
printf "\n"



# First, run the .env creation wizard
if ! [[ -f .env ]]; then
  ./init-scripts/createEnv.sh
else
  echo -e "\e[33mEnvironment file .env already exists. Recreate it ? (Y/n)\e[39m"
  read proceed
  if [[ "$proceed" == "Y" ]] || [[ "$proceed" == "y" ]] || [[ -z $proceed ]]; then
    ./init-scripts/createEnv.sh
  fi
fi

cat .env

echo -e "\e[33mPlease check .env file (above). Continue ? (Y/n)\e[39m"
read proceed
[[ "$proceed" == "n" ]] || [[ "$proceed" == "N" ]] && { echo "Aborting"; exit 1; }

source .env

echo -e "\e[33mCreating docker-compose.yml file symlink\e[39m"
if [[ "$RECORDING_DISABLED" == "false" ]]; then
  docker_compose_file=docker-compose.recording.yml
else
  docker_compose_file=docker-compose.basic.yml
fi
if [[ -L docker-compose.yml ]]; then
  echo -e "\e[33mSymlink already exists. Overriding it\e[39m"
  rm docker-compose.yml
fi
ln -s $docker_compose_file docker-compose.yml
ls -l docker-compose.yml


# chmod the log directory
chmod -R 777 log/

if [[ "$MULTITENANCY_ENABLED" == "true"]]; then
  echo -e "\e[33mMulti-tenancy enabled : updating nginx config files for wildcard domains\e[39m"
  sed -i -e 's#server_name.*#server_name ~^(.*\\.|)$NGINX_HOSTNAME$;#' data/proxy/nginx/sites.template*
fi

# Let's encrypt
echo -e "\e[36mUse Let's Encrypt ?(y/N) :\e[39m"
read RUN_LETSENCRYPT
if [[ "$RUN_LETSENCRYPT" == "y" ]] || [[ "$RUN_LETSENCRYPT" == "Y" ]]; then
  if [[ "$MULTITENANCY_ENABLED" == true]]; then
    echo -e "\e[33mMulti-tenancy enabled : make sure you selected certbot/dns-ovh as Docker image and populated .ovhapi. Generate certificates now ? (Y/n)\e[39m"
	read proceed
	if [[ "$proceed" == "y" ]] || [[ "$proceed" == "Y" ]] || [[ -z $proceed ]]; then
      ./init-scripts/init-letsencrypt_dns-ovh.sh
	else
	  exit 1
	fi
  else
    echo -e "\e[33mMake sure certbot is enabled as Docker image in docker-compose.yml file. Generate certificates now ? (Y/n)\e[39m"
	read proceed
	if [[ "$proceed" == "y" ]] || [[ "$proceed" == "Y" ]] || [[ -z $proceed ]]; then
      ./init-scripts/init-letsencrypt.sh
	else
	  exit 1
	fi
  fi
fi

# Make systemD
echo -e "\e[36mCreate systemd daemon ?(Y/n) :\e[39m"
read MK_SYSTEMD
if [[ "$MK_SYSTEMD" == "y" ]] || [[ "$MK_SYSTEMD" == "Y" ]] || [[ -z $MK_SYSTEMD ]]; then
  ./init-scripts/arawa-create-systemd.sh
fi

# Final test
sleep 5

echo -e "\e[36mTesting the API...\e[39m"
curl https://$URL_HOST/bigbluebutton/api/