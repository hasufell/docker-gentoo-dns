FROM       hasufell/gentoo-amd64-paludis:latest
MAINTAINER Julian Ospald <hasufell@gentoo.org>

# global flags
RUN echo -e "*/* acl bash-completion ipv6 kmod openrc pcre readline unicode \
zlib pam ssl sasl bzip2 urandom crypt tcpd \
-acpi -bindist -cairo -consolekit -cups -dbus -dri -gnome -gnutls -gtk -ogg \
-opengl -pdf -policykit -qt3support -qt5 -qt4 -sdl -sound -systemd -truetype \
-vim -vim-syntax -wayland -X" \
	>> /etc/paludis/use.conf

# update world with our USE flags
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x

# per-package flags
# check these with "cave show <package-name>"
RUN mkdir /etc/paludis/use.conf.d/ && echo -e \
"net-dns/unbound dnstap gost \
" \
	>> /etc/paludis/use.conf.d/unbound.conf

# install unbound
RUN chgrp paludisbuild /dev/tty && cave resolve -z unbound -x

# install tools
RUN chgrp paludisbuild /dev/tty && \
	cave resolve -z app-admin/supervisor app-admin/sudo sys-process/htop -x

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 53/udp 10000/tcp

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

