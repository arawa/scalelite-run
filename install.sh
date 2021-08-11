#!bin/bash

# Custom certs
printf "\n"
echo -e "\e[33mBefore running this script, please put if needed the custom certs to the arawa dir :\e[39m"
echo -e "\e[33mcp {fullchain.pem,privkey.pem} data/arawa/cert/\e[39m"
printf "\n"

# First, run the .env creation wizard
bash ./init-scripts/createEnv.sh

# chmod the log directory
chmod -R 777 log/

# Let's encrypt
echo -e "\e[36mUse Let's Encrypt ?(y/N) :\e[39m"
read RUN_LETSENCRYPT
if [[ "$RUN_LETSENCRYPT" == "y" ]] || [[ "$RUN_LETSENCRYPT" == "Y" ]]; then
  bash ./init-scripts/init-letsencrypt.sh
fi

# Create DB if needed
RECORDING_DISABLED=$(grep RECORDING_DISABLED .env | cut -d '=' -f2)
if [[ "$RECORDING_DISABLED" == false ]]; then
	ARG_SYSTEMD=" storage"
  	echo -e "\e[36mCreate the DB with the following command:\e[39m"
	echo -e "\e[36mdocker exec -it scalelite-api bin/rake db:setup/\e[39m"
else
	ARG_SYSTEMD=""
fi

# Make systemD
echo -e "\e[36mCreate systemd daemon ?(Y/n) :\e[39m"
read MK_SYSTEMD
if [[ "$MK_SYSTEMD" == "y" ]] || [[ "$MK_SYSTEMD" == "Y" ]] || [[ -z $MK_SYSTEMD ]]; then
  bash ./init-scripts/arawa-create-systemd.sh $ARG_SYSTEMD
fi

# Final test
URL_HOST=$(grep URL_HOST .env | cut -d '=' -f2)
echo -e "\e[36mTesting the API...\e[39m"
curl https://$URL_HOST/bigbluebutton/api