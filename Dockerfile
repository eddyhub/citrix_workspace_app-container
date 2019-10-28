FROM ubuntu:18.04
MAINTAINER Eduard A. <github-mail@container42.de>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y vim firefox apt-utils xdg-utils libwebkit2gtk-4.0-37 libgtk2.0-0 libxmu6 libxpm4 dbus-x11 xauth libcurl3 openssh-server wget && \
    #apt-get install -y vim firefox apt-utils xdg-utils libwebkit2gtk-4.0-37 libwebkitgtk-1.0-0 libxmu6 libxpm4 dbus-x11 xauth libcurl3 openssh-server wget && \
    mkdir /var/run/sshd && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "AddressFamily inet" >> /etc/ssh/sshd_config && \
    sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd

RUN wget $(wget -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html | sed -ne '/icaclient_.*deb/ s/<a .* rel="\(.*\)" id="downloadcomponent">/https:\1/p' | sed -e 's/\r//g') -O /tmp/icaclient.deb
RUN dpkg -i /tmp/icaclient.deb && \
    apt-get -y -f install && \
    rm /tmp/icaclient.deb && \
    cd /opt/Citrix/ICAClient/keystore/cacerts/ && \
    ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/ && \
    c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ 

RUN useradd -m -s /bin/bash receiver && \
    echo "pref(\"browser.tabs.warnOnClose\", false);" >> /usr/lib/firefox/browser/defaults/preferences/syspref.js && \
    echo "pref(\"browser.startup.homepage\", \"https://duckduckgo.com/\");" >> /usr/lib/firefox/browser/defaults/preferences/syspref.js

USER receiver
WORKDIR /home/receiver
RUN mkdir -p .local/share/applications .config && \
    xdg-mime default wfica.desktop application/x-ica

USER root
CMD ["/usr/sbin/sshd", "-D"]
