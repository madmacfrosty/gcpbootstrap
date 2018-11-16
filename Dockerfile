FROM alpine

COPY scripts /usr/local/bin/
RUN cd /usr/local/bin && chmod +x *.sh

RUN apk update \
  && apk add ca-certificates \
  && apk add curl \
  && apk add --update python \
  && update-ca-certificates  \
  && rm -rf /var/cache/apk/*
  
ARG helm=helm-v2.11.0-linux-amd64.tar.gz
ARG google_sdk=google-cloud-sdk-224.0.0-linux-x86_64.tar.gz
ENV https_proxy=${https_proxy}
ENV http_proxy=${http_proxy}

RUN curl -L https://storage.googleapis.com/kubernetes-helm/${helm} -o ${helm} \
  && tar -xzvf ${helm} \
  && rm ${helm} \
  && cd linux-amd64 \
  && mv helm tiller /usr/local/bin \
  && cd .. \
  && rm -rf linux-amd64

RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${google_sdk} -o ${google_sdk} \
  && tar -xzvf ${google_sdk} \
  && rm ${google_sdk}
  
ENV PATH=${PATH}:/google-cloud-sdk/bin

RUN curl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o cfssl \
  && curl https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o cfssljson \
  && chmod +x cfssl cfssljson \
  && mv cfssl cfssljson /usr/local/bin