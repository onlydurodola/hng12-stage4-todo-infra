[app_server]
${public_ip} 
ansible_user=ubuntu 
ansible_ssh_private_key_file=/home/ubuntu/.ssh/numbers.pem
ansible_ssh_common_args='-o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o ConnectTimeout=30 -o ConnectionAttempts=5'