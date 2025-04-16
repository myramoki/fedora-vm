# Setup tomcat with basic stuff

# https://www.atlantic.net/dedicated-server-hosting/how-to-install-tomcat-on-fedora/

printf "\n#### BEGIN CONFIG : Tomcat\n\n"

read -t 5 -p "?? Version of Tomcat to install 9, 10 or 11 [$DEFAULT_TOMCAT_VERSION] " respTomcatVersion

if [[ -z $respTomcatVersion ]]; then
    respTomcatVersion=$DEFAULT_TOMCAT_VERSION
fi

case $respTomcatVersion in
"9")  downloadVersion="9.0.104" ;;
"10") downloadVersion="10.1.40" ;;
"11") downloadVersion="11.0.6" ;;
*) printf "ERR: bad version\n" && exit ;;
esac

tomcatDownloadUrl="https://archive.apache.org/dist/tomcat/tomcat-${downloadVersion//.*/}/v${downloadVersion}/bin/apache-tomcat-${downloadVersion}.tar.gz"

printf ".. get tomcat port and ssl libs\n"

dnf -y -q install authbind tomcat-native

printf ".. add tomcat users\n"

useradd -m -d /opt/tomcat -U -s /bin/false tomcat
usermod -a -G tomcat bn

printf ".. add authbind\n"

touch /etc/authbind/byport/80 /etc/authbind/byport/443
chmod 500 /etc/authbind/byport/80 /etc/authbind/byport/443
chown tomcat /etc/authbind/byport/80 /etc/authbind/byport/443

printf ".. fetch tomcat\n"

curl -sL $tomcatDownloadUrl | tar xzvf - -C /opt/tomcat --strip-components=1 --exclude='*/webapps/examples' --exclude='*/webapps/docs'

mkdir -p /opt/tomcat/.local/bin
chown -R tomcat:tomcat /opt/tomcat/
chmod -R u+x /opt/tomcat/bin
chmod -R go+rX /opt/tomcat

cd /opt/tomcat/.local/bin
sudo -u tomcat curl -O $GITDIR/scripts/tomcat/updatedes -O $GITDIR/scripts/tomcat/updateops
sudo -u tomcat chmod +x /opt/tomcat/.local/bin/*

printf "#- setup systemctl for tomcat\n"

printf '[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat
UMask=0022

Environment="JAVA_HOME=%s"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:///dev/urandom"
#Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:///dev/urandom -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000"
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
' $JAVA_HOME > /etc/systemd/system/tomcat.service

printf "#- configure tomcat\n"

sed -i \
	-e '/<\/tomcat-users>/i \  <user username="tomcat" password="tomcat" roles="manager-gui" />' \
	-e '/<\/tomcat-users>/i \  <user username="server" password="5Star*" roles="manager-script" />' \
	/opt/tomcat/conf/tomcat-users.xml

sed -i \
	-e '/Valve/i <!--' \
	-e '/Manager/i -->' \
	/opt/tomcat/webapps/manager/META-INF/context.xml

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

printf "\n#### FINISHED CONFIG : Tomcat\n\n"
