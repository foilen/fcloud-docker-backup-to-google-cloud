FROM ubuntu:16.04

RUN export TERM=dumb ; \
  apt-get update && apt-get install -y \
    apt-transport-https \
    curl less vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
  
RUN export TERM=dumb ; \
  echo "deb https://packages.cloud.google.com/apt cloud-sdk-xenial main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && apt-get install -y \
    google-cloud-sdk \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
  
COPY /assets/* /

VOLUME /backupRoot

CMD /backup.sh
