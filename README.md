# Scalelite through Docker Compose

## Getting started
- `cp {fullchain.pem,privkey.pem} data/arawa/cert/`
- run `bash install.sh`
- **If using the recording feature with SSL, at the end of the install :**
  - `docker exec -it scalelite-api bin/rake db:setup`