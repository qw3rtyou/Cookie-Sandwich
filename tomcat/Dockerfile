FROM tomcat:8.5.69-jdk8-openjdk

RUN rm -rf /usr/local/tomcat/webapps/*

COPY server.xml /usr/local/tomcat/conf/

RUN chmod -R 755 /usr/local/tomcat/webapps/