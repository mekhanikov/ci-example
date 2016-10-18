FROM jenkinsci/jenkins:2.24
USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN chown -R jenkins:jenkins /etc/ssh/ssh_config
USER jenkins
ENV JAVA_OPTS="-Xmx8192m -Djava.awt.headless=true -Dhudson.Main.development=true -Djenkins.install.runSetupWizard=false"

#COPY plugins.txt /usr/share/jenkins/plugins.txt
#RUN cat /usr/share/jenkins/plugins.txt
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
COPY id_rsa /var/jenkins_home/.ssh/id_rsa
RUN /usr/local/bin/install-plugins.sh \
 docker-slaves \
 github-branch-source:1.8 \
 maven-plugin:2.7.1 \
 job-dsl:1.51 \
 docker-plugin:0.16.2 \
 git:3.0.0 \
 gitlab-plugin:1.4.2
