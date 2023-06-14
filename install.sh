#!bin/bash

# Custom certs
printf "\n"
echo -e "\e[33mBefore running this script, please put if needed the custom certs to the arawa dir :\e[39m"
echo -e "\e[33mcp {fullchain.pem,privkey.pem} data/arawa/cert/\e[39m"
printf "\n"

# First, run the .env creation wizard
./init-scripts/createEnv.sh
cat .env

echo -e "\e[33mPlease check generated .env file (above). Continue ? (Y/n)\e[39m"
read proceed
[[ "$proceed" == "n" ]] || [[ "$proceed" == "N" ]] && { echo "Aborting"; exit 1; }

source .env

# chmod the log directory
chmod -R 777 log/


if [[ "$MULTITENANCY_ENABLED" == true]]; then
  echo -e "\e[33mMulti-tenancy enabled : updating nginx config.\e[39m"
  sed -i -e 's#server_name.*#server_name ~^(.*\\.|)$NGINX_HOSTNAME$;#' data/proxy/nginx/sites.template*
fi

# Let's encrypt
echo -e "\e[36mUse Let's Encrypt ?(y/N) :\e[39m"
read RUN_LETSENCRYPT
if [[ "$RUN_LETSENCRYPT" == "y" ]] || [[ "$RUN_LETSENCRYPT" == "Y" ]]; then
  if [[ "$MULTITENANCY_ENABLED" == true]]; then
    echo -e "\e[33mMulti-tenancy enabled : make sure you selected certbot/dns-ovh as Docker image and populated .ovhapi. Proceed now ? (Y/n)\e[39m"
	read proceed
	if [[ "$proceed" == "y" ]] || [[ "$proceed" == "Y" ]] || [[ -z $proceed ]]; then
      ./init-scripts/init-letsencrypt_dns-ovh.sh
	else
	  exit 1
	fi
  else
   ./init-scripts/init-letsencrypt.sh
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