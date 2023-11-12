FROM ubuntu:jammy
LABEL maintainer="Julio Gutierrez julio.guti+nordvpn@pm.me"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y curl iputils-ping libc6 wireguard && \
    curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
    apt-get install -y /tmp/nordrepo.deb && \
    apt-get update -y && \
    apt-get install -y nordvpn && \
    apt-get remove -y nordvpn-release && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf \
		/tmp/* \
		/var/cache/apt/archives/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

COPY /rootfs /
RUN chmod +x /usr/bin/* && \
    chmod +x /etc/services.d/nordvpn/run && \
    chmod +x /etc/services.d/nordvpn/finish && \
    chmod +x /etc/services.d/nordvpn/data/check && \
    chmod +x /etc/fix-attrs.d/* && \
    chmod +x /etc/cont-init.d/*

CMD nord_login && nord_config && nord_connect && nord_migrate && nord_watch
