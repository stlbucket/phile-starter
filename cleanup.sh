#!/usr/bin/env bash
ansible-playbook ansible/scrub-repos.yml
ansible-playbook ansible/cleanup-repos.yml
rm docker-run-pg-10.sh
rm sqitch
