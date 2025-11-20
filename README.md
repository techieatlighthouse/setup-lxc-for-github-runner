
# SETUP PROXMOX LXC for GITHUB RUNNER

This script install docker and github runner which will be used enabling CICD.

## Prerequisites - Proxmox Host Configuration

Before setting up Docker and GitHub runner inside the LXC container, you need to configure the container permissions on the Proxmox host. These settings are required for Docker to run properly inside the LXC container.

**On the Proxmox host**, run the following commands (replace `<CTID>` with your container ID):

```bash
echo "features: nesting=1,keyctl=1" >> /etc/pve/lxc/<CTID>.conf
echo "lxc.apparmor.profile: unconfined" >> /etc/pve/lxc/<CTID>.conf
```

**What these settings do:**
- `nesting=1`: Enables container nesting, allowing Docker containers to run inside the LXC container
- `keyctl=1`: Enables kernel keyring support, required for certain Docker operations
- `lxc.apparmor.profile: unconfined`: Disables AppArmor restrictions for the container

**After adding these settings, restart the LXC container** for the changes to take effect:

```bash
pct stop <CTID>
pct start <CTID>
```

## Getting Started

Clone this repository:

```bash
git clone https://github.com/techieatlighthouse/setup-lxc-for-github-runner.git
cd setup-lxc-for-github-runner
```

Or download directly using curl:

```bash
curl -L https://github.com/techieatlighthouse/setup-lxc-for-github-runner/archive/refs/heads/main.tar.gz -o setup-lxc-for-github-runner.tar.gz
tar -xzf setup-lxc-for-github-runner.tar.gz
cd setup-lxc-for-github-runner-main
```

## Usage

### 1. Install Docker

Run the Docker installation script:

```bash
chmod +x install-docker.sh
./install-docker.sh
```

This script will install Docker and configure it for your system.

### 2. Install GitHub Runner

Run the GitHub runner installation script:

```bash
chmod +x install-runner.sh
./install-runner.sh
```

This script will install and configure the GitHub Actions runner for CI/CD workflows.
