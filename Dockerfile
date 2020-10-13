FROM ubuntu:18.04

LABEL maintainer ishibashi-futos <ishibashi.futos@outlook.com>

RUN apt-get update -y \
 && apt-get install -y curl gcc bridge-utils gcc make \
 && curl https://jp.softether-download.com/files/softether/v4.34-9745-rtm-2020.04.05-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz > /vpnserver.tar.gz \
 && tar -zxvf /vpnserver.tar.gz \
 && rm -f /vpnserver.tar.gz

WORKDIR /vpnserver
RUN sed -i -e "s/read tmp/#read tmp/g" .install.sh \
 && sed -i "2iexport tmp=1" .install.sh \
 && make
RUN chmod 600 * && chmod 700 vpncmd vpnserver

ENTRYPOINT /docker-entry.sh
