FROM jenkins/jenkins:2.468-jdk17

USER root

RUN curl -fs https://get.docker.com -o get-docker.sh \
  && chmod a+x get-docker.sh \
  && ./get-docker.sh \
  && rm -f get-docker.sh

USER jenkins
