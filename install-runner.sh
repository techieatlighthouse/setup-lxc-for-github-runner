#!/bin/bash
set -e

# 1. Create runner user if not exists
if id "runner" &>/dev/null; then
    echo "User 'runner' already exists."
else
    echo "Creating user 'runner'..."
    adduser --disabled-password --gecos "" runner

    # Set password 'changeme'
    echo "runner:changeme" | chpasswd

    # Add runner to sudo group
    usermod -aG sudo runner
fi

TARGET_DIR="/home/runner/actions-runner"
mkdir -p "$TARGET_DIR"
chown runner:runner "$TARGET_DIR"

# 2. Detect latest linux-x64 runner
echo "Fetching latest linux-x64 runner URL..."
ASSET_URL=$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" \
    | grep "browser_download_url" \
    | grep "linux-x64" \
    | head -n1 \
    | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
    echo "Could not find linux-x64 asset URL via GitHub API. Aborting."
    exit 1
fi

echo "Latest runner: $ASSET_URL"

# 3. Download as runner user
sudo -u runner curl -L -o "$TARGET_DIR/actions-runner-linux-x64.tar.gz" "$ASSET_URL"

# 4. Extract and set ownership
echo "Extracting runner..."
cd "$TARGET_DIR"
rm -rf bin externals run.sh runsvc.sh *_diag || true
sudo -u runner tar -xzf actions-runner-linux-x64.tar.gz --strip-components=0
rm -f actions-runner-linux-x64.tar.gz

chown -R runner:runner "$TARGET_DIR"

echo "Runner installed at $TARGET_DIR"
echo "Password for user 'runner' is: changeme"
echo "------------------------------------------------------"
echo "Now run the following as the runner user:"
echo "  su - runner"
echo "  cd ~/actions-runner"
echo "  ./config.sh --url <repo-url> --token <token>"
echo "------------------------------------------------------"