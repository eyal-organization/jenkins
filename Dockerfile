#from jenkins/jenkins:2.332.3-lts-alpine
from jenkins/jenkins:2.401.3-lts-alpine
# --> updated line that works (fix postured by Max, one of the course students, inside the Q&A forum, since the older line makes it broken).
# --> see below updated plugin installation lines as well (old lines were commented)
USER root
# Pipeline
#RUN /usr/local/bin/install-plugins.sh workflow-aggregator && \
#    /usr/local/bin/install-plugins.sh github && \
#    /usr/local/bin/install-plugins.sh ws-cleanup && \
#    /usr/local/bin/install-plugins.sh greenballs && \
#    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
#    /usr/local/bin/install-plugins.sh kubernetes && \
#    /usr/local/bin/install-plugins.sh docker-workflow && \
#    /usr/local/bin/install-plugins.sh kubernetes-cli && \
#    /usr/local/bin/install-plugins.sh github-branch-source
RUN jenkins-plugin-cli --plugins workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source

# install Maven, Java, Docker, AWS
RUN apk add --no-cache maven \
    openjdk8 \
    docker \
    gettext

# Kubectl
RUN  wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
