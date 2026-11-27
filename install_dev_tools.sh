#!/usr/bin/env bash

set -e

echo "Starting DevOps tools installation..."

# Check operating system
if [ ! -f /etc/os-release ]; then
    echo "Error: Cannot identify operating system."
    exit 1
fi

source /etc/os-release

if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
    echo "Error: This script supports Ubuntu and Debian only."
    exit 1
fi

# Update package lists
sudo apt update

# Install required utilities
sudo apt install -y ca-certificates curl

# 1. Install Docker
if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
    docker --version
else
    echo "Installing Docker..."

    sudo install -m 0755 -d /etc/apt/keyrings

    sudo curl -fsSL "https://download.docker.com/linux/$ID/gpg" \
        -o /etc/apt/keyrings/docker.asc

    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID $VERSION_CODENAME stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update

    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    echo "Docker installed successfully."
fi

# 2. Install Docker Compose
if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose is already installed."
    docker compose version
else
    echo "Installing Docker Compose..."
    sudo apt install -y docker-compose-plugin
    echo "Docker Compose installed successfully."
fi

# 3. Install Python 3.9 or newer
if command -v python3 >/dev/null 2>&1; then
    if python3 -c 'import sys; exit(0 if sys.version_info >= (3,9) else 1)'; then
        echo "Python 3.9 or newer is already installed."
        python3 --version
    else
        echo "Python version is too old. Installing Python..."
        sudo apt install -y python3
    fi
else
    echo "Installing Python..."
    sudo apt install -y python3
fi

# Install pip and virtual environment support
sudo apt install -y python3-pip python3-venv

# 4. Install Django using pip in a virtual environment
VENV_DIR="$HOME/.venvs/dev-tools"

if [ -x "$VENV_DIR/bin/python" ] && \
   "$VENV_DIR/bin/python" -c "import django" >/dev/null 2>&1; then
    echo "Django is already installed."
    "$VENV_DIR/bin/python" -m django --version
else
    echo "Installing Django..."

    mkdir -p "$HOME/.venvs"
    python3 -m venv "$VENV_DIR"

    "$VENV_DIR/bin/python" -m pip install --upgrade pip
    "$VENV_DIR/bin/python" -m pip install django

    echo "Django installed successfully."
fi

# 5. Add the current user to the docker group
if ! getent group docker >/dev/null 2>&1; then
    echo "Creating docker group..."
    sudo groupadd docker
fi

if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    echo "User $USER is already in the docker group."
else
    echo "Adding user $USER to the docker group..."
    sudo usermod -aG docker "$USER"
    echo "User added to the docker group. Restart your session for this change to take effect."
fi

# 6. Verify installations
echo ""
echo "========== Installation check =========="

docker --version
docker compose version
python3 --version
"$VENV_DIR/bin/python" -m django --version

echo ""
echo "All tools are installed successfully!"
