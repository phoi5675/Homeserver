FROM nextcloud

RUN apt-get update && apt-get install smbclient vim ffmpeg -y