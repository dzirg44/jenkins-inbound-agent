ARG JENKINS_AGENT_VERSION="4.7-1-alpine"

FROM jenkins/agent:${JENKINS_AGENT_VERSION}

ARG JNLP_PROTOCOL_3_DISABLED=true
ARG DOCKER_CLI="20.10.3-r0"
ARG AWS_CLI_DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip"
# By default, the JNLP3-connect protocol is disabled due to known stability
# and scalability issues. You can enable this protocol using the
# JNLP_PROTOCOL_OPTS environment variable:
#
# JNLP_PROTOCOL_OPTS=-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false
#
# The JNLP3-connect protocol should be enabled on the Master instance as well.

ENV JNLP_PROTOCOL_OPTS=-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=${JNLP_PROTOCOL_3_DISABLED}

# Disable the JVM PerfDataFile feature by adding `-XX:-UsePerfData` to the
# `JAVA_OPTS` environment variable. Otherwise, a superfluous
# `/tmp/hsperfdata_root` directory will be included in the final Docker image.

ENV JAVA_OPTS -XX:-UsePerfData

# apk must be run as root.
USER root
RUN apk add --no-cache git docker-cli=${DOCKER_CLI}

RUN wget  ${AWS_CLI_DOWNLOAD_URL} -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -b /usr/local/bin && rm -rf aws && rm -rf awscliv2.zip


