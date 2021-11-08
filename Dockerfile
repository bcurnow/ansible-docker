FROM python:3.8

# Install dependencies to build Ansible
RUN apt-get update && apt-get -y install --no-install-recommends \
      build-essential \
      cargo \
      libssl-dev \
      libffi-dev \
      python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip

RUN python -m pip --disable-pip-version-check install ansible

# Install additional dependencies
RUN apt-get update && apt-get -y install --no-install-recommends \
      avahi-daemon \
      libnss-mdns \
      sshpass \
      vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ansible

COPY docker-files/etc/ /etc/

COPY docker-files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["ansible", "all", "-m", "ping", "--ask-pass"]
