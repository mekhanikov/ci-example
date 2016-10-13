FROM jenkinsci/jenkins:2.24
USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
USER jenkins
ENV JAVA_OPTS="-Xmx8192m"
#COPY plugins.txt /usr/share/jenkins/plugins.txt
#RUN cat /usr/share/jenkins/plugins.txt
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh docker-slaves github-branch-source:1.8 maven-plugin:2.7.1 job-dsl:1.51 docker-plugin:0.16.2
