#!/bin/bash
# TeamSpeak 3 Installer
# Tested on CentOS 5.x or higher
# 23/02/2013 v0.2
# 14/02/2013 v0.3
# Author Oscar Sanchez.
# http://www.oscars.mx
# CopyLeft - Script under license of creativecommons
# http://creativecommons.org/licenses/by-nc-nd/3.0/
# http://creativecommons.org/licenses/by-nc-nd/3.0/deed.es


#Start Script
{
echo "################################################"
echo "Select an option:"
echo "1) Set up new TeamSpeak3 server"
echo "2) Exit"
echo "################################################"
read start
if test $start -eq 1; then
	echo "Specify server name that you want for the Teamspeak Server (eg. publico.ts3la.com):"
	read sn
	echo "Specify your architecture (remember that 32bit is x86 and 64bit is amd64):"
	read arch
	echo "Enter the current version of TeamSpeak Server (ie. 3.0.13.8):"
	read ts3sv
	echo "Specify the IP Adress of your voice, filetransfer and query (eg. 198.100.152.134):"
	read ipa
	echo "Specify the voice port that you want for the server (default is 9987):"
	read vp
	echo "Specify the filetransfer port that you want for the server (default is 30033):"
	read ftp
	echo "Specify the query port that you want for the server (default is 10011):"
	read qp
echo
echo
echo "################################################"
echo "Downloading TeamSpeak3 Server $arch bit version"
echo "################################################"
wget http://teamspeak.gameserver.gamed.de/ts3/releases/$ts3sv/teamspeak3-server_linux-$arch-$ts3sv.tar.gz
echo "################################################"
echo "Setting up the server..."
echo "################################################"
tar xfv teamspeak3-server_linux-$arch-$ts3sv.tar.gz
mv teamspeak3-server_linux-$arch $sn
cd $sn
touch ts3server.ini
echo "machine_id=" >> ts3server.ini
echo "default_voice_port=$vp" >> ts3server.ini
echo "voice_ip=$ipa" >> ts3server.ini
echo "licensepath=" >> ts3server.ini
echo "filetransfer_port=$ftp" >> ts3server.ini
echo "filetransfer_ip=$ipa" >> ts3server.ini
echo "query_port=$qp" >> ts3server.ini
echo "query_ip=$ipa" >> ts3server.ini
echo "dbplugin=ts3db_sqlite3" >> ts3server.ini
echo "dbpluginparameter=" >> ts3server.ini
echo "dbsqlpath=sql/" >> ts3server.ini
echo "dbsqlcreatepath=create_sqlite/" >> ts3server.ini
echo "logpath=logs" >> ts3server.ini
echo "logquerycommands=1" >> ts3server.ini
echo "COMMANDLINE_PARAMETERS="inifile=ts3server.ini"" >> ts3server_startscript.sh
chmod +x ts3server_startscript.sh
echo "################################################"
echo "Adding TeamSpeak Server to the Boot"
echo "################################################"
crontab -l | { cat; echo "@reboot /root/$sn/ts3server_startscript.sh start"; } | crontab -
echo "################################################"
echo "Starting Server"
echo "################################################"
./ts3server_startscript.sh start
sleep 10
echo -ne '\n'
echo "Server Installed."
echo "Quitting"
exit
else
echo "Quitting"
exit
echo -ne '\n'
fi
echo "The log file is located at: /var/log/ts3installer.log and you can find there your token and server query details"
} 2>&1 | tee /var/log/ts3installer.log
#End Script