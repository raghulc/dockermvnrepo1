# Specify the stage name for multi stage build
FROM maven AS stage1
# Copy the contents inside the current SRC folder in maven project to the SRC folder of the maven app in docker
COPY ./src /usr/src/app/src
# Copy the pom.xml from current maven project app folder to the app folder inside the docker maven app
COPY pom.xml /usr/src/app
# Run the maven command and point it to the pom.xml and it will build the war file
RUN mvn -f /usr/src/app/pom.xml clean package

FROM tomcat
# Remove the exisitng app in tomcat
RUN rm -fr /usr/local/tomcat/webapps/ROOT
# Copy the app that has been built by the stage 1 which is myjapp.war as ROOT.war in the destination
COPY --from=stage1 /usr/src/app/target/myjapp1.war /use/local/tomcat/webapps/ROOT.war
