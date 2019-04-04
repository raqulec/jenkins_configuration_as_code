FROM jenkins/jenkins:lts
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
COPY checkServerStatus_job.yaml /usr/share/jenkins/ref/checkServerStatus_job.yaml
COPY delay_job.yaml /usr/share/jenkins/ref/delay_job.yaml
COPY herokuDeploy_job.yaml /usr/share/jenkins/ref/herokuDeploy_job.yaml
COPY pipeline.yaml /usr/share/jenkins/ref/pipeline.yaml
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt