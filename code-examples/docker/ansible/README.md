This repository contains an example setup for running Ansible within a Docker-Compose environment. It comes with a **controller** and a **target** container based on Debian 12, enabling local testing of Ansible playbooks, roles and tasks without installing Ansible on a host system.

**Features**

-	Fully containerized Ansible setup.
-	No need to install Ansible locally.
- Customizable target container using a Dockerfile.
- Easy to test and validate playbooks in a controlled environment.

**How to run**

- `docker-compose up -d --build`
- `docker exec -it ansible-controller ssh-keyscan -H ansible-target >> ~/.ssh/known_hosts`
- `docker exec -it ansible-controller ansible-playbook -i /ansible-setup/inventory /ansible-setup/playbooks/main.yml`