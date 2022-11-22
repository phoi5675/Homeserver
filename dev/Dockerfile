FROM ubuntu:20.04

# Write your ip here
ENV IP="192.168.35.233"
ENV DISPLAY=${IP}:0

# Set timezone to make run cron based on GMT+9.
ENV TZ="Asia/Seoul"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Change apt list to mirror in Korea.
RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

# Install packages.
# ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive

# Install firefox
RUN apt-get update
RUN apt-get install firefox software-properties-common  -y -f -qq

# Install chrome
# RUN apt-get install wget -y -f
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN dpkg -i ./google-chrome-stable_current_amd64.deb

# Install Korean fonts
RUN apt-get install fonts-nanum -y -f -qq

# Setup VPN
RUN add-apt-repository ppa:nm-l2tp/network-manager-l2tp
RUN apt-get install network-manager-l2tp -y -f -qq

# Setup VPN with shell script
COPY ./vpn_on.sh /vpn_on.sh
COPY ./vpn_config.sh /vpn_config.sh
RUN chmod 755 /vpn*.sh

# Turn VPN on
RUN bash /vpn_config.sh

# Make entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]