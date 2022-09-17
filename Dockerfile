FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    wget \
    unzip \
    psmisc \
    git \
    python3-virtualenv \
    virtualenv \
    python3-dev \
    python3-pip \
    libffi-dev \
    build-essential \
    tzdata \
    zlib1g-dev \
    libjpeg-dev \
    ffmpeg \
    haproxy
    
EXPOSE 80

ARG tag=devel

WORKDIR /opt/octoprint

#Create an octoprint user
RUN useradd -ms /bin/bash octoprint && adduser octoprint dialout
RUN chown octoprint:octoprint /opt/octoprint
USER octoprint

#This fixes issues with the volume command setting wrong permissions
RUN mkdir /home/octoprint/.octoprint
USER root
RUN chown -R octoprint:octoprint /home/octoprint
RUN chmod -R 755 /home/octoprint
USER octoprint

#Install Octoprint
RUN git clone --branch $tag https://github.com/foosel/OctoPrint.git /opt/octoprint \
  && virtualenv venv \
  && ./venv/bin/pip install .

RUN /opt/octoprint/venv/bin/python -m pip install \
https://github.com/AliceGrey/OctoprintKlipperPlugin/archive/master.zip \
https://github.com/birkbjo/OctoPrint-Themeify/archive/master.zip \
https://github.com/jneilliii/OctoPrint-UltimakerFormatPackage/archive/master.zip \
https://github.com/eyal0/OctoPrint-PrintTimeGenius/archive/master.zip

VOLUME /home/octoprint/.octoprint

### Klipper setup ###

USER root

RUN apt-get install -y sudo

COPY klippy.sudoers /etc/sudoers.d/klippy

RUN useradd -ms /bin/bash klippy

# This is to allow the install script to run without error
RUN ln -s /bin/true /bin/systemctl

USER octoprint

WORKDIR /home/octoprint

RUN git clone https://github.com/KevinOConnor/klipper

COPY install-ubuntu-22.04.sh /home/octoprint/klipper/scripts/

USER root
RUN chmod a+x /home/octoprint/klipper/scripts/install-ubuntu-22.04.sh

USER octoprint

RUN ./klipper/scripts/install-ubuntu-22.04.sh

USER root

# Clean up hack for install script
RUN rm -f /bin/systemctl

COPY start.py /
COPY runklipper.py /

CMD ["/start.py"]
