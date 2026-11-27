Lesson 3: Dev Tools Installation Script
The install_dev_tools.sh Bash script automates the installation and verification of the following tools on Ubuntu or Debian:

- Docker
- Docker Compose
- Python 3.9 or newer
- pip and Python virtual environment support
- Django (installed using pip in a virtual environment)
  The script checks whether tools are already installed before installing them, so it can be run more than once.

It also adds the current user to the docker group, allowing Docker commands to be run without sudo where the Docker installation supports this setup. A new login session is required for the group change to take effect.
Requirements

- Ubuntu or Debian
- Bash
- Internet connection
- sudo privileges

# Usage

From the repository directory, make the script executable (if needed):
chmod u+x install_dev_tools.sh

Run the script:
./install_dev_tools.sh

Verify installed tools

The script prints the installed versions at the end. You can also run these commands manually:
docker --version
docker compose version
python3 --version
"$HOME/.venvs/dev-tools/bin/python" -m django --version
