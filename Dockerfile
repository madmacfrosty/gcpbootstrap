FROM alpine

RUN apk update \
  && apk add ca-certificates \
  && apk add curl \
  && apk add --update python \
  && update-ca-certificates  \
  && rm -rf /var/cache/apk/*

ARG google_sdk=google-cloud-sdk-224.0.0-linux-x86_64.tar.gz
ENV https_proxy=${https_proxy}
ENV http_proxy=${http_proxy}
  
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${google_sdk} -o ${google_sdk} \
  && tar -xzvf ${google_sdk} \
  && rm ${google_sdk} \
  && ln -s /google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
  