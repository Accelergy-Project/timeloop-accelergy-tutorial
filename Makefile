#
# Ultility Makefile to build/push Docker images
#
VERSION := 0.2

USER    := nelliewu95
REPO    := timeloop-accelergy-tutorial

NAME    := ${USER}/${REPO}
TAG     := $$(git log -1 --pretty=%h)
IMG     := ${NAME}:${TAG}
LATEST  := ${NAME}:latest


all:	build


# Pull all submodules

pull:
	@for i in src/*; do (echo "Pull $$i"; cd $$i; git pull); done


# Build and tag docker image

build:
	"${DOCKER_EXE}" build ${BUILD_FLAGS} \
          --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
          --build-arg VCS_REF=${TAG} \
          --build-arg BUILD_VERSION=${VERSION} \
          -t ${IMG} .
	"${DOCKER_EXE}" tag ${IMG} ${LATEST}
 

# Push docker image

push:
	"${DOCKER_EXE}" push ${NAME}
 

# Lint the Dockerfile

lint:
	"${DOCKER_EXE}" run --rm -i hadolint/hadolint < Dockerfile || true


# Login to docker hub

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}

