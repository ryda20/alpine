# borrowed from https://github.com/linuxserver/docker-baseimage-alpine/blob/master/Dockerfile

FROM alpine:3.16

ENV \
	MY_USER="stduser" \
	MY_GROUP="stduser" \
	MY_HOME="/stduser" \
	MY_APPS="/app" \
	MY_WORKS="/workspace" \
	MY_CONF="/config"

# create standar user for rootless running: stdUser with uid/gid = 1000/1000
# environment variables
ENV \
	PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
	PUID=99 \
	# container/su-exec UID:GID
	PGID=1000

RUN \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
	bash \
	# sudo \
	# ca-certificates \
	# coreutils \
	# curl \
	# procps \
	# shadow package content usermod and groudmod command for easy change user id/ group id
	shadow \
	tzdata #ENDRUN
#
RUN \
	echo "**** create ${PUID}:${PGID} - ${MY_USER}:${MY_GROUP} and make our folders ****" && \
	# option -o allow to use exist id on the system
	addgroup -g ${PGID} ${MY_GROUP} && \
	adduser -D -u ${PUID} -s /bin/ash ${MY_USER} -G ${MY_GROUP} -h ${MY_HOME} && \
	# -h DIR          Home directory
	# -g GECOS        GECOS field
	# -s SHELL        Login shell
	# -G GRP          Group
	# -S              Create a system user
	# -D              Don't assign a password
	# -H              Don't create home directory
	# -u UID          User id
	# -k SKEL         Skeleton directory (/etc/skel)
	echo "*** create directories ***" && \
	mkdir -p ${MY_HOME} && \
	mkdir -p ${MY_APPS} ${MY_WORKS} ${MY_CONF} && \
	echo "*** apply permission for directories was created ***" && \
	chown -R ${MY_USER}:${MY_GROUP} ${MY_HOME} && \
	echo "**** cleanup ****" && \
	rm -rf /tmp/* && \
	rm -rf /var/cache/*
