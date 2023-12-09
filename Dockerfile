FROM docker.io/library/debian:bookworm-20231120-slim
ARG USER=pi

RUN <<EOT
  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes \
    sudo \
    virtualenv
EOT

RUN useradd \
  --create-home \
  --shell /bin/bash\
  ${USER}

COPY <<EOT /etc/sudoers.d/pi
${USER} ALL=(ALL:ALL) NOPASSWD:ALL
EOT

WORKDIR /home/${USER}
COPY --chown=${USER}:${USER} localhost.sh .
COPY --chown=${USER}:${USER} localhost.yml .
RUN chmod +x localhost.sh

USER ${USER}
CMD ["/bin/bash"]
