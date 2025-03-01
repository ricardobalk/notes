# Notes

Collection of personal notes, quirky ideas, and random thoughts.

### [code-examples/docker/neo4j](./code-examples/docker/neo4j)
Small Neo4j Graph Database example that automatically imports a basic set of data from a CSV on its first run.


### [code-examples/docker/metabase](./code-examples/docker/metabase)
Demo of Metabase, a business intelligence tool that allows users to visualize and analyze data from various sources. Runs Metabase, Postgres and two demo databases. One of them is using MySQL 8 and the other is using Postgres.


## [code-examples/docker](./code-examples/docker)
This directory contains a few of my example Docker setups for different applications and services. Each of these directories represents a hands-on example of how I work with Docker in different environments. Feel free to explore, use, or improve them!


### [code-examples/docker/ansible](./code-examples/docker/ansible)
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

