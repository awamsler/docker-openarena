FROM httpd

# https://bitbucket.ci-services:8443/projects/MON/repos/fnt_monitoring/browse/installation/rhel7/Dockerfile

ADD supervisord.conf /etc/supervisord.d/


# Add config files
ADD ./conf/ /opt/openarena-0.8.8/baseoa/

# Add startup script
ADD startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

# add map pack
add oacmp-volume1-v3.zip /tmp/

# put files in /data and link it to htdocs + baseoa

# Install packages & download and unzip OpenArena
RUN apt-get update && apt-get install -y curl unzip && \ 
	curl -o /tmp/openarena.zip http://download.tuxfamily.org/openarena/rel/088/openarena-0.8.8.zip && \ 
	unzip /tmp/openarena.zip -d /opt && \ 
	rm -f /tmp/openarena.zip && \
	unzip /tmp/oacmp-volume1-v3.zip -d /opt/openarena-0.8.8 && \ 
	rm -f /tmp/oacmp-volume1-v3.zip && \
	cp /opt/openarena-0.8.8/baseoa/z_oacmp-volume1-v3.pk3 /usr/local/apache2/htdocs/ && \
	yum install -y supervisor && \
	yum clean all

# Expose ports
EXPOSE 27950/udp 27960/udp 80/tcp

# Run startup script
CMD ["/opt/startup.sh"]

