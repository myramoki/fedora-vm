printf "\n#### BEGIN CONFIG : Tomcat SSL\n\n"

printf "#- fetch JKS\n"

curl -sL -o /opt/tomcat/conf/localhost.jks https://raw.githubusercontent.com/myramoki/fedora-vm/main/localhost.jks
chown tomcat:tomcat /opt/tomcat/conf/localhost.jks

printf "#- configure tomcat\n"

sed -i 's/<Context>/<Context antiResourceLocking="true">/' /opt/tomcat/conf/context.xml

gawk -i inplace -v inplace::suffix=.bak '
NF == 0 {blank+=1}
NF != 0 {blank=0}

/<!--/ {comment=1}
/-->/ {comment=0}

/Connector port="(80|443)"/ && comment == 0 {stop=1}
/\/>/ && stop == 1 {stop=0; next}

/<Service name="Catalina">/ {
	print
	print "    <Connector port=\"80\" protocol=\"HTTP/1.1\"\n\
               connectionTimeout=\"20000\"\n\
               redirectPort=\"443\" />\n\
\n\
    <Connector port=\"443\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\"\n\
               maxThreads=\"150\"\n\
               SSLEnabled=\"true\" scheme=\"https\" secure=\"true\"\n\
               keystoreFile=\"conf/localhost.jks\" keystorePass=\"test@123\" keyAlias=\"server\"\n\
               clientAuth=\"false\"\n\
               sslProtocol=\"TLSv1.2\" />"
    next
}

{
	if (comment==1 || stop==0 && blank <= 1) print
}
' /opt/tomcat/conf/server.xml

gawk -i inplace -v inplace::suffix=.bak '/Environment/ && !x {print "Environment=\"GRADLE_HOME=/opt/gradle\""; x=1} 1' /etc/systemd/system/tomcat.service

printf "#- restart tomcat\n"

systemctl daemon-reload
systemctl restart tomcat

printf "#- setup firewall\n"

ufw allow http
ufw allow https

printf "\n#### FINISHED CONFIG : Tomcat SSL\n\n"
