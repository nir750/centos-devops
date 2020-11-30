FROM centos:centos7

ENV container docker
LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /sys/fs/selinux:/sys/fs/selinux:ro -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"

RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

# Reinstall all packages to get man pages for them
RUN yum -y reinstall "*" && yum clean all

# Swap out the systemd-container package and install all useful packages
RUN yum -y install \
           kernel \
           e2fsprogs \
           sos \
           crash \
           strace \
           ltrace \
           tcpdump \
           abrt \
           pcp \
           systemtap \
           perf \
           bc \
           blktrace \
           btrfs-progs \
           ethtool \
           file \
           findutils \
           gcc \
           gdb \
           git \
           glibc-common \
           glibc-utils \
           hwloc \
           iotop \
           iproute \
           iputils \
           less \
           pciutils \
           ltrace \
           mailx \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           numactl \
           numactl-devel \
           passwd \
           perf \
           pip \
           pip3 \
           procps-ng \
           psmisc \
           screen \
           strace \
           sysstat \
           systemtap-client \
           tar \
           tcpdump \
           vim-enhanced \
           xauth \
           which \
           ostree \
           rpm-ostree \
           docker \
           python-docker-py \
           docker-selinux \
           kubernetes-client \
           kubernetes-node \
           kubernetes-devel \
           kubernetes-master \
           gdb-gdbserver \
           vim-minimal \
           bash-completion \
           subscription-manager \
           python-rhsm \
           rootfiles \
           yum-utils \
           && yum clean all

# Set default command
CMD ["/usr/bin/bash"]

# Install AWS_CLI_VERSION_1.18.117
RUN pip install awscli --upgrade --user
ENV PATH=~/.local/bin:$PATH
ADD templates /usr/local/bin/templates
RUN mkdir ~/.aws && touch ~/.aws/credentials

# Install GOOGLE_CLOUD_SDK
RUN yum -y install google-cloud-sdk

# Install AZURE_CLI
RUN yum -y install azure-cli

# Install ANSIBLE_FOR_CENTOS_7
FROM centos:centos7
MAINTAINER Toshio Kuratomi <tkuratomi@ansible.com>
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN mkdir /opt/ansible/
RUN git clone http://github.com/ansible/ansible.git /opt/ansible/ansible
WORKDIR /opt/ansible/ansible
RUN git submodule update --init
ENV PATH /opt/ansible/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/ansible/library

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
RUN unzip terraform_0.11.11_linux_amd64.zip
RUN mv terraform /usr/local/bin/
RUN terraform --version
