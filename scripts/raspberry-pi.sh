### Ubuntu 18.04 https://dev.to/wesleybatista/setup-raspberry-pi-3-model-b-with-ubuntu-server-and-ssh-over-wifi-4d41

### setup rpi connectivity
## enable wifi and ssh
# host
# set ssid/psswd in wpa_suplicant.conf/network-config
# Raspbian - cp wpa_supplicant.conf /Volumes/boot/
# Ubuntu - sudoedit /etc/netplan/50-cloud-init.yaml and copy network-config into it
touch /Volumes/boot/ssh
## attach rpi to ip address
# sudo add rpi to /etc/hosts



### k3s
## create pcloud sudo user
# rpi
sudo adduser pcloud
sudo usermod -aG sudo pcloud
sudoedit /boot/firmware/cmdline.txt # append cgroup_memory=1 cgroup_enable=memory
sudo shutdown -r now
## install k3s without traefik
# pcloud@rpi
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --no-deploy traefik" K3S_KUBECONFIG_MODE="644" sh
# worker
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.111:6443 K3S_TOKEN=K10ad9f018be91d743f3142246e848def8859145f8f86e08ac761938ec37b1d876e::server:e5adcf3075ce25c6d42729c7823a0d5a sh -
## copy kubeconfig on host
# pcloud@rpi
sudo chown pcloud /etc/rancher/k3s/k3s.yaml
# host
scp pcloud@rpi:/etc/rancher/k3s/k3s.yaml ~/.k3s.kubeconfig
sed -i -e 's/127\.0\.0\.1/rpi/g' ~/.k3s.kubeconfig
printf "\n\n#k3s kubeconfig\nexport KUBECONFIG=~/.k3s.kubeconfig\n" >> ~/.bash_profile
source ~/.bash_profile
kubectl get pods -A



### ingress
## traefik 2.0
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update
kubectl create namespace traefik
helm --namespace=traefik install traefik traefik/traefik \
     --set additionalArguments="{--providers.kubernetesingress,--global.checknewversion=true}" \
     --set ports.traefik.expose=True



### setup docker    DO NOT INSTALL DOCKER, IT MESSES UP WITH k3s iptables
# sudo adduser docker
# sudo usermod -aG sudo docker
# sudo apt-get install docker.io
