FROM python:3.6-stretch

MAINTAINER Ezra Kissel <ezkissel@indiana.edu>

EXPOSE 6714/tcp

RUN apt-get update
RUN apt-get -y install sudo cmake gcc libaprutil1-dev libapr1-dev libcurl4-gnutls-dev libjansson-dev python-setuptools python-zmq python-netifaces python-daemon python-dev

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/ibp && \
    mkdir /etc/periscope && \
    echo "ibp:x:${uid}:${gid}:IBP-EODN,,,:/home/ibp:/bin/bash" >> /etc/passwd && \
    echo "ibp:x:${uid}:" >> /etc/group && \
    echo "ibp ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ibp && \
    chmod 0440 /etc/sudoers.d/ibp && \
    chown ${uid}:${gid} -R /home/ibp && \
    chown ${uid}:${gid} -R /opt
    
USER ibp
ENV HOME /home/ibp
WORKDIR $HOME

RUN git clone https://github.com/periscope-ps/blipp
RUN git clone https://github.com/periscope-ps/libunis-c
RUN git clone https://github.com/datalogistics/ibp_server

ADD build.sh .
RUN bash ./build.sh

ADD blippd.json /etc/periscope
ADD dlt-client.pem /etc/periscope

ADD run.sh .
CMD bash ./run.sh
