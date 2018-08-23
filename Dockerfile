# docker run -dit --privileged -p 8888:80 --name syslog syslog:v1
# docker exec -it syslog bash
# iniciar; netstat -tulpen
# pendiente crear el entrypoint subiendo los servicios
FROM ubuntu:16.04
MAINTAINER Jose Baez https://github.com/josebaez028
RUN apt-get update
RUN apt-get -y install build-essential wget net-tools tacacs+ ntp
RUN apt-get clean
RUN wget https://sourceforge.net/projects/remote-syslog/files/remote-syslog-latest-AMD64.tar
RUN tar -xvf remote-syslog-latest-AMD64.tar && \
cd syslog-latest && \
cp rsinstaller /bin && \
echo "2" | rsinstaller -f && \
cd /etc/init.d && \
touch iniciar && \
chmod 755 iniciar && \
cp iniciar /bin

RUN echo 'cd /etc/init.d\n\
sh apache2 restart\n\
sh tacacs_plus restart\n\
sh syslog-ng restart\n\
sh ntp restart\n\
/bin/bash\n '\
>> /etc/init.d/iniciar

RUN echo 'cd /etc/init.d\n\
sh apache2 restart\n\
sh tacacs_plus restart\n\
sh syslog-ng restart\n\
sh ntp restart\n\
/bin/bash\n '\
>> /bin/iniciar

EXPOSE 514
EXPOSE 49
EXPOSE 80
EXPOSE 123
VOLUME [ "/root" ]
WORKDIR [ "/root" ]

CMD [ "sh", "-c", "cd; exec bash -i" ]
