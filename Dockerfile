# Stage 2: Run WAR in Tomcat (Alpine)
FROM tomcat:9.0-jdk8

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR built by Jenkins
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
