
# Ansible installation
sudo dnf update -y
sudo dnf install ansible -y
ansible --version
sudo useradd ansadmin
sudo passwd ansadmin
sudo echo ansadmin:ansadmin | chpasswd
