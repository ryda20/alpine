# borrowed from https://github.com/linuxserver/docker-baseimage-alpine/blob/master/Dockerfile

FROM alpine:3.16

ENV \
	USER_NAME="stduser" \
	GROUP_NAME="stduser" \
	USER_HOME_DIR="/stduser" \
	USER_APP_DIR="/app" \
	USER_WORKSPACE_DIR="/workspace" \
	USER_CONFIG_DIR="/config"

# create standar user for rootless running: stdUser with uid/gid = 1000/1000
# environment variables
ENV \
	PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
	PUID=1000 \
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
	echo "**** create ${PUID}:${PGID} - ${USER_NAME}:${GROUP_NAME} and make our folders ****" && \
	addgroup -g ${PGID} ${GROUP_NAME} && \
	adduser -D -u ${PUID} -s /bin/ash ${USER_NAME} -G ${GROUP_NAME} -h ${USER_HOME_DIR} && \
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
	mkdir -p ${USER_APP_DIR} ${USER_HOME_DIR} ${USER_WORKSPACE_DIR} ${USER_CONFIG_DIR} && \
	echo "*** apply permission for directories was created ***" && \
	chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME_DIR} ${USER_APP_DIR} ${USER_WORKSPACE_DIR} ${USER_CONFIG_DIR} && \
	echo "**** cleanup ****" && \
	rm -rf /tmp/* && \
	rm -rf /var/cache/*
