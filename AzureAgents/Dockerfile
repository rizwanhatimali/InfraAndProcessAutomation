FROM ubuntu:20.04

ARG SOURCE_PATH
ENV src=$SOURCE_PATH

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    dirmngr \ 
    gnupg \
    software-properties-common \
    net-tools \
    nmap \
    dnsutils \
    traceroute \
    wget \ 
    zip  \
    build-essential

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb > packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update
 
 
RUN apt-get install -y --no-install-recommends \
    dotnet-sdk-6.0 \
    dotnet-sdk-7.0 \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

RUN mkdir -p /scripts
COPY /Installers  /scripts
COPY /Helpers  /scripts
WORKDIR /scripts

RUN chmod +x *.sh

#RUN ./dotnetcore-sdk.sh
  
ENV dotnet=/usr/bin/dotnet

RUN ./powershell.sh

WORKDIR /scripts

RUN ./python.sh

WORKDIR /scripts

RUN ./Java.sh

WORKDIR /scripts

RUN ./mono.sh

RUN mono --version

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]