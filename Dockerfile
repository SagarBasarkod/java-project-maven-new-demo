FROM tomcat:10-jre21-temurin-jammy

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR as ROOT.war so it runs at   http://host:8080/
COPY target/myapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
