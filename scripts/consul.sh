#!/bin/bash -eux

ACCOUNT_ID="120"
CONSUL_VERSION="1.4.3"
CONSUL_DC="us-east1"
CONSUL_SRV1="192.168.1.41"
CONSUL_SRV2="192.168.1.42"
CONSUL_SRV3="192.168.1.43"
CONSUL_SRV4="192.168.1.44"
CONSUL_SRV5="192.168.1.45"

sudo groupadd --gid ${ACCOUNT_ID} consul
sudo useradd --gid ${ACCOUNT_ID} --uid ${ACCOUNT_ID} --comment "consul" --create-home consul
sudo mkdir -p /etc/consul.d
sudo mkdir /var/consul
sudo chown consul:consul /var/consul
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
sudo unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin/
rm -f consul_${CONSUL_VERSION}_linux_amd64.zip

sudo cat <<EOF > /etc/consul.d/config.json
{
  "server": false,
  "datacenter": "${CONSUL_DC}",
  "data_dir": "/var/consul",
  "bind_addr": "0.0.0.0",
  "client_addr": "127.0.0.1",
  "retry_join": ["${CONSUL_SRV1}", "${CONSUL_SRV2}", "${CONSUL_SRV3}", "${CONSUL_SRV4}", "${CONSUL_SRV5}"],
  "log_level": "INFO",
  "enable_syslog": true,
  "acl_enforce_version_8": false
}
EOF

sudo chmod 640 /etc/consul.d/config.json
sudo chown -R consul:consul /etc/consul.d/

sudo cat <<EOF > /etc/systemd/system/consul.service
### BEGIN INIT INFO
# Provides:          consul
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Consul agent
# Description:       Consul service discovery framework
### END INIT INFO

[Unit]
Description=Consul server agent
Requires=network-online.target
After=network-online.target
Documentation=https://consul.io/docs/

[Service]
User=consul
Group=consul
PIDFile=/var/run/consul/consul.pid
PermissionsStartOnly=true
ExecStartPre=-/bin/mkdir -p /var/run/consul
ExecStartPre=/bin/chown -R consul:consul /var/run/consul
ExecStart=/usr/local/bin/consul agent \
    -config-dir /etc/consul.d/ \
    -pid-file=/var/run/consul/consul.pid
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF

# Enable on boot
sudo systemctl enable consul
