FROM python:3.8

ARG USER_ID=0
ARG GROUP_ID=0
ARG USER_NAME=anisible
ARG GROUP_NAME=${USER_NAME}

# Don't attempt to set the user to the root user (uid=0) or group (gid=0)
RUN if [ ${USER_ID:-0} -eq 0 ] || [ ${GROUP_ID:-0} -eq 0 ]; then \
        groupadd ${GROUP_NAME} \
        && useradd -g ${GROUP_NAME} ${USER_NAME} \
        ;\
    else \
        groupadd -g ${GROUP_ID} ${GROUP_NAME} \
        && useradd -l -u ${USER_ID} -g ${GROUP_NAME} ${USER_NAME} \
        ;\
    fi \
    && install -d -m 0755 -o ${USER_NAME} -g ${GROUP_NAME} /home/${USER_NAME} \
    && mkdir -p /etc/sudoers.d  \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}-all-nopasswd

# Install dependencies to build Ansible
RUN apt-get update && apt-get -y install --no-install-recommends \
      build-essential \
      cargo \
      libssl-dev \
      libffi-dev \
      python3-dev

RUN python -m pip install --upgrade pip

RUN python -m pip --disable-pip-version-check install ansible

# Install debugging dependencies
RUN apt-get -y install --no-install-recommends \
      less \
      sudo \
      vim

# Install ansible dependencies
RUN apt-get -y install --no-install-recommends \
      sshpass

# Remove the apt lists as they'll quickly get stale and take up unnecessaray space
RUN rm -rf /var/lib/apt/lists/*

COPY ./docker-files/home/.* /home/${USER_NAME}/

WORKDIR /ansible

USER ${USER_NAME}

ENTRYPOINT ["ansible"]

CMD ["all", "-m", "ping", "--ask-pass"]
