.PHONY: help install check syntax dry-run ssh-users base ntopng laravel-go postgresql all

ANSIBLE_CFG := $(shell pwd)/ansible.cfg
export ANSIBLE_CONFIG := $(ANSIBLE_CFG)

help:
	@echo "Available commands:"
	@echo "  make install      - Install Ansible roles and collections"
	@echo "  make check        - Check Ansible syntax"
	@echo "  make dry-run      - Run ansible-playbook in check mode (dry run)"
	@echo "  make ssh-users    - Create SSH users with certificate auth"
	@echo "  make base         - Run app-server-base role only"
	@echo "  make ntopng       - Run ntopng role only"
	@echo "  make laravel-go   - Run laravel-go role only"
	@echo "  make postgresql   - Run PostgreSQL role only"
	@echo "  make all          - Run all roles (full setup)"

install:
	@cd ansible && ansible-galaxy role install -r requirements.yml --ask-pass --ask-become-pass|| true

check:
	@cd ansible && ansible-playbook --syntax-check playbooks/main.yml --ask-pass --ask-become-pass

dry-run:
	@cd ansible && ansible-playbook playbooks/main.yml --check --ask-pass --ask-become-pass

ssh-users:
	@cd ansible && ansible-playbook playbooks/main.yml --tags ssh-users --ask-pass --ask-become-pass

base:
	@cd ansible && ansible-playbook playbooks/main.yml --tags base-server --ask-pass --ask-become-pass

ntopng:
	@cd ansible && ansible-playbook playbooks/main.yml --tags ntopng --ask-pass --ask-become-pass

laravel-go:
	@cd ansible && ansible-playbook playbooks/main.yml --tags laravel-go --ask-pass --ask-become-pass

postgresql:
	@cd ansible && ansible-playbook playbooks/main.yml --tags postgresql --ask-pass --ask-become-pass

all:
	@cd ansible && ansible-playbook playbooks/main.yml --ask-pass --ask-become-pass
