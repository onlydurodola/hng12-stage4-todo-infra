#!/bin/bash
set -e

# Run Ansible playbook and capture the exit code
sleep 120 && ANSIBLE_CONFIG=/home/ubuntu/hng12-stage4-todo-infra/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/hng12-stage4-todo-infra/ansible/inventory.ini /home/ubuntu/hng12-stage4-todo-infra/ansible/playbook.yaml -vvv
exit_code=$?

# If the exit code is 4 (SSH connection issue), check if the app is accessible
if [ $exit_code -eq 4 ]; then
  echo "SSH connection issue detected (exit code 4). Checking if app is accessible..."
  curl -k -s -o /dev/null -w "%{http_code}" https://oluwatobiloba.tech
  curl_exit_code=$?
  http_status=$(curl -k -s -o /dev/null -w "%{http_code}" https://oluwatobiloba.tech)
  if [ $curl_exit_code -eq 0 ] && [ "$http_status" -eq 200 ]; then
    echo "App is accessible (HTTP 200). Ignoring SSH connection issue."
    exit 0
  else
    echo "App is not accessible (HTTP $http_status). Failing deployment."
    exit $exit_code
  fi
fi

# If exit code is not 4, pass through the original exit code
exit $exit_code