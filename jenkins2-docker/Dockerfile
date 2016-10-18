FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

COPY config.xml /var/jenkins_home/config.xml
RUN chmod 600 /var/jenkins_home/config.xml
RUN chown root:root /var/jenkins_home/config.xml
# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

## Jenkins home directory is a volume, so configuration and build history
## can be persisted and survive image upgrades
#VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.9.0
ENV TINI_SHA fa23d1e20732501c3bb8eeeca423c89ac80ed452

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.25}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=1c4a750b7d7102c5fc9b78550fd3dcc93d7374da

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha1sum -c -

ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}
COPY  id_rsa /var/jenkins_home/id_rsa_priv1
COPY  id_rsa /var/jenkins_home/id_rsa_priv2
#COPY config.xml /var/jenkins_home/config.xml
#COPY config.xml /usr/local/bin/config.xml
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY config.xml /usr/share/jenkins/ref/config.xml.override
COPY config.xml /usr/share/jenkins/ref/config.xml
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state


# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
#COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
USER jenkins
ENV JAVA_OPTS="-Xmx8192m -Djava.awt.headless=true -Dhudson.Main.development=true -Djenkins.install.runSetupWizard=false"
#ENV JENKINS_OPTS=""

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
#VOLUME /var/jenkins_home

#COPY plugins.txt /usr/share/jenkins/plugins.txt
#RUN cat /usr/share/jenkins/plugins.txt
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
COPY config.xml /usr/share/jenkins/ref/config.xml.override
RUN /usr/local/bin/install-plugins.sh \
 docker-slaves \
 github-branch-source:1.8 \
 maven-plugin:2.7.1 \
 job-dsl:1.51 \
 docker-plugin:0.16.2 \
 git:3.0.0 \
 gitlab-plugin:1.4.2
COPY config.xml /usr/share/jenkins/ref/config.xml.override
COPY config.xml /usr/share/jenkins/ref/config.xml
COPY id_rsa /var/jenkins_home/.ssh/id_rsa

#VOLUME /var/jenkins_home
#RUN rm -rf /var/jenkins_home/secrets/initialAdminPassword

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]