# Proxmox Homeserver
Each continaer is being run in an Alpine Docker LXC, created by the [Proxmox VE Helper Scripts](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker).

## Post-install
This script upgrades all packages and adds watchtower as a docker container, to automatically update containers in the LXC. Run the command:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fennoms/homeserver-proxmox/main/post_install.sh)"
```
