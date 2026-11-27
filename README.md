# Lesson 3: Dev Tools Installation Script

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

Usage

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

# Lesson 4: Docker — Django, PostgreSQL and Nginx

This project demonstrates how to containerize a Django application and run it together with a PostgreSQL database and an Nginx web server using Docker Compose.

- Project structure:
  lesson-4-docker/
  ├── Dockerfile
  ├── docker-compose.yml
  ├── requirements.txt
  ├── manage.py
  ├── docker_django/
  │ ├── **init**.py
  │ ├── asgi.py
  │ ├── settings.py
  │ ├── urls.py
  │ └── wsgi.py
  └── nginx/
  └── nginx.conf

- Technologies:

* Docker
* Docker Compose
* Python 3.12
* Django 5.2
* PostgreSQL 16
* Nginx

- Services

The application consists of three containers:
Django — runs the Python web application on port 8000.
PostgreSQL — provides the database for the Django application.
Nginx — acts as a reverse proxy and forwards incoming HTTP requests to Django.
Nginx listens on port 80 and forwards requests to http://django:8000.

- Docker configuration

The Dockerfile:

Uses the official Python 3.12 slim image.
Sets /app as the working directory.
Installs Python dependencies from requirements.txt.
Copies the application files into the container.
Exposes port 8000.
Starts the Django development server.

The docker-compose.yml file defines all three services, their configuration, dependencies, and the persistent PostgreSQL volume.

- Run the application

From the lesson-4-docker directory, build the image and start the containers:
docker compose up -d --build

Check the running containers:
docker compose ps

Apply Django database migrations:
docker compose exec django python manage.py migrate

- Verify the application
  Open the application in your browser:
  http://localhost

Check the HTTP response:
curl -I http://localhost

Check the Django version:
docker compose exec django python -m django --version

Check PostgreSQL readiness:
docker compose exec db pg_isready -U django_user -d django_db

- Stop the containers
  To stop and remove the containers:
  docker compose down

To stop the containers and also remove the PostgreSQL data volume:
docker compose down -v

Note: The second command permanently deletes the database data stored in the Docker volume.

- Result
  The Django application, PostgreSQL database, and Nginx reverse proxy run successfully as separate Docker containers managed by Docker Compose. The application is accessible through Nginx at http://localhost.
