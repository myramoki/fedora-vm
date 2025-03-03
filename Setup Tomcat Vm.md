# Install VM

## Install & Networking

- Download Ubuntu Server ISO - https://ubuntu.com/download/server

- Create Virtual Machine

  - Quick Create
    - Local Installation Source - Select ISO
    - Unselect vm will run Windows
    - Name vm something
  - Edit Settings
    - Security - Enable Secure Boot
    - Template - UEFI

- Connect & Start Vm

  - Default selections

  - Networking

    - Info at https://askubuntu.com/questions/1064921/scripting-netplan-for-static-ip-address

    - Choose Manual

      - Subnet: `192.168.50.0/23`
      - Address: `192.168.51.1`
      - Gateway: `192.168.50.1`
      - Nameserver: `192.168.50.1`

    - In `/etc/netplan/50-cloud-init.yaml`, the above will look like this:

      ```yaml
      network:
        ethernets:
          eth0:
            addresses:
              - 192.168.51.1/23
            nameservers:
              addresses:
                - 192.168.50.1
              search: []
            routes:
              - to: default
                via: 192.168.50.1
        version: 2
      ```

    - User setup

      - Name: `Biznuvo`
      - Server: `ubuntu-dev`
      - Username: `bn`
      - Password: `Pass@123`

    - Install OpenSSH

    - Reboot

    - Test ssh connection to `192.168.51.1` using SSH client

- Configure mDNS

  Info at https://gist.github.com/jimmydo/e4943950427234408a1aaa2d7beda8b6

  ```bash
  sudo sed -i 's/#MulticastDNS=no/MulticastDNS=yes/' /etc/systemd/resolved.conf

  sudo mkdir -p /etc/systemd/network/$(ls /run/systemd/network).d
  printf "[Network]\nMulticastDNS=yes\n" | sudo tee /etc/systemd/network/$(ls /run/systemd/network).d/override.conf

  sudo resolvectl mdns eth0 yes
  ```

## Setup Basic Software Software

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y net-tools nmap cifs-utils unzip
sudo sed -i 's#/usr/games:/usr/local/games:##' /etc/environment

sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

## Configure UFW

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

## Install Java

```bash
sudo apt install -y openjdk-8-jdk-headless
sudo sed -i $'$a\\\nJAVA_HOME='$(dirname $(dirname $(dirname $(realpath $(which java))))) /etc/environment
```

## Install Gradle

- Download gradle into /opt
- Adjust environment file so there are some starting points for path and env variables

```bash
curl -sL -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-8.10.2-bin.zip
sudo unzip /tmp/gradle.zip -d /opt
cd /opt
sudo ln -s gradle-8.10.2 gradle
sudo sed -i -e $'$a\\\nGRADLE_HOME=/opt/gradle' -e 's#/snap/bin#/snap/bin:/opt/gradle/bin#' /etc/environment
sudo sed -i 's#/snap/bin#/snap/bin:/opt/gradle/bin#' /etc/sudoers
```

## Install Tomcat

- Authbind is needed to map tomcat to ports below 1024
- tcnative is needed for using OpenSSL

```bash
sudo apt install -y authbind libtcnative-1

sudo touch /etc/authbind/byport/80 /etc/authbind/byport/443
sudo chmod 500 /etc/authbind/byport/80 /etc/authbind/byport/443
sudo chown tomcat /etc/authbind/byport/80 /etc/authbind/byport/443

sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
sudo usermod -a -G tomcat bn

curl -sL https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz \
	| sudo tar xzvf - -C /opt/tomcat \
		--strip-components=1 \
		--exclude='*/webapps/examples' --exclude='*/webapps/docs'

sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin
sudo chmod -R go+rX /opt/tomcat

printf '[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat
UMask=0022

Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx2048M -server -XX:+UseParallelGC -Djava.net.preferIPv4Stack=true"

ExecStart=/usr/bin/authbind --deep /opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
' | sudo tee /etc/systemd/system/tomcat.service

sudo sed -i \
	-e '/<\/tomcat-users>/i \  <user username="tomcat" password="tomcat" roles="manager-gui" />' \
	-e '/<\/tomcat-users>/i \  <user username="server" password="5Star*" roles="manager-script" />' \
	/opt/tomcat/conf/tomcat-users.xml

sudo sed -i \
	-e '/Valve/i <!--' \
	-e '/Manager/i -->' \
	/opt/tomcat/webapps/manager/META-INF/context.xml

sudo systemctl daemon-reload
sudo systemctl start tomcat

sudo ufw allow 8080
```

Use in case you need to find issues: `journalctl -xeu tomcat.service`

## Update For New VM

```bash
read -p "?? Update IP Address: " updateip
read -p "?? Update Hostname: " updatehost

sudo sed -i 's/192.168.51.1/'$updateip'/' /etc/netplan/50-cloud-init.yaml
sudo sed -i 's/starter/'$updatehost'/' /etc/hostname
sudo reboot
```
