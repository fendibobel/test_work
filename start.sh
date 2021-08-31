#!/bin/bash

export TF_VAR_sel_account=
export TF_VAR_sel_token=
export TF_VAR_user_password=

cd ~/terraform/work/
terraform init
terraform apply -target=module.project_with_user
terraform apply

sleep 10s

allip=(`terraform output -raw server_ip`)

rm -f ~/.ssh/known_hosts

# generator ansible hosts
echo "[haproxy]" > ~/ansible/hosts
echo "rmq-0 ansible_host="${allip[0]}" ansible_user=root" >> ~/ansible/hosts 
echo "[rabbitmq]" >> ~/ansible/hosts
counter=1
for ip in ${allip[*]:1}; do
    echo "rmq-"$counter" ansible_host="$ip" ansible_user=root" >> ~/ansible/hosts
    let counter++
done

# generator groupvars 
counter=0
local_ip=(`terraform output -raw server_local_ip`)
echo "rmq_local_ip:" > ~/ansible/group_vars/haproxy.yml
echo "rmq_local_ip:" > ~/ansible/group_vars/rabbitmq.yml
for ip in ${local_ip[*]}; do
    echo "  - "$ip >> ~/ansible/group_vars/haproxy.yml
    echo "  - "$ip >> ~/ansible/group_vars/rabbitmq.yml
    let counter++
done

ansible-playbook ~/ansible/playbook/rmq.yml --limit=rabbitmq
ansible-playbook ~/ansible/playbook/hp.yml --limit=haproxy
