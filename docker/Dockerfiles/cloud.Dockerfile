FROM nextcloud

RUN apt-get update && apt-get install smbclient -y
RUN apt-get install -y vim ffmpeg