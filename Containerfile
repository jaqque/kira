FROM docker.io/library/debian:bookworm-20231120-slim
ARG USER=pi

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes \
    sudo \
    systemd \
    systemd-sysv \
    virtualenv

RUN useradd \
  --create-home \
  --shell /bin/bash\
  ${USER}

COPY <<EOT /etc/sudoers.d/${USER}
${USER} ALL=(ALL:ALL) NOPASSWD:ALL
EOT

WORKDIR /home/${USER}
COPY --chown=${USER}:${USER} localhost.sh .
COPY --chown=${USER}:${USER} localhost.yml .
RUN chmod +x localhost.sh
RUN usermod -p '$1$passIspi$c3WwfAXgP4UPGlNwVmHuB1' pi
# openssl passwd -salt passIspi pi

CMD [ "/usr/lib/systemd/systemd" ]
