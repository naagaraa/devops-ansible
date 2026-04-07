.PHONY: help install check syntax dry-run ssh-users base ntopng laravel-go postgresql all

ANSIBLE_CFG := $(shell pwd)/ansible.cfg
export ANSIBLE_CONFIG := $(ANSIBLE_CFG)

help:
	@echo "Available commands:"
	@echo "  make install      - Install Ansible roles and collections"
	@echo "  make check        - Check Ansible syntax"
	@echo "  make dry-run      - Run ansible-playbook in check mode (dry run)"
	@echo "  make ssh-users    - Create SSH users with certificate auth"
	@echo "  make base         - Run ubuntu-base role only"
	@echo "  make ntopng       - Run ntopng role only"
	@echo "  make laravel-go   - Run laravel-go role only"
	@echo "  make postgresql   - Run PostgreSQL role only"
	@echo "  make all          - Run all roles (full setup)"

install:
	@cd ansible && ansible-galaxy role install -r requirements.yml || true

check:
	@cd ansible && ansible-playbook --syntax-check playbooks/main.yml

dry-run:
	@cd ansible && ansible-playbook playbooks/main.yml --check

ssh-users:
	@cd ansible && ansible-playbook playbooks/main.yml --tags ssh-users

base:
	@cd ansible && ansible-playbook playbooks/main.yml --tags ubuntu-base

ntopng:
	@cd ansible && ansible-playbook playbooks/main.yml --tags ntopng

laravel-go:
	@cd ansible && ansible-playbook playbooks/main.yml --tags laravel-go

postgresql:
	@cd ansible && ansible-playbook playbooks/main.yml --tags postgresql

all:
	@cd ansible && ansible-playbook playbooks/main.yml
