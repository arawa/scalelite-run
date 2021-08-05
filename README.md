# Scalelite through Docker Compose

## Getting started  
- `cp .env.example .env`
- Customize `.env`


## Set as a systemd service
- run `bash ./arawa-create-systemd.sh`
  - Use with the "`storage`" arg to setup a recording-enabled version
    - `bash ./arawa-create-systemd.sh storage`
- Service should be started.
