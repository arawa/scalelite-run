# Scalelite through Docker Compose

## Getting started  
- `cp .env.example .env`
- Customize `.env`
- Set the correct rights to the log directory
  - `chmod -R 660 log/`
- When started, create the initial db
  - `docker exec -it scalelite-api bin/rake db:setup`


## Set as a systemd service
- run `bash ./arawa-create-systemd.sh`
  - Use with the "`storage`" arg to setup a recording-enabled version
    - `bash ./arawa-create-systemd.sh storage`
- Service should be started.
