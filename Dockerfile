FROM nelliewu/accelergy-timeloop-infrastructure:latest AS builder

#
# Main image
#
FROM nelliewu/accelergy-timeloop-infrastructure:latest

LABEL maintainer="nelliewu@mit.edu"

# Arguments
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="nelliewu95/tutorial"
LABEL org.label-schema.description="Tutorial exercise for Timeloop/Accelergy tools"
LABEL org.label-schema.url="http://accelergy.mit.edu/"
LABEL org.label-schema.vcs-url="https://github.com/nelliewu95/timeloop-accelergy-tutorial"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="Wu"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -it --rm -v ~/workspace:/home/workspace nelliewu/tutorial"

ENV SRC_DIR=/usr/local/src
ENV BIN_DIR=/usr/local/bin

# Get all source
WORKDIR $SRC_DIR

COPY src/ $SRC_DIR/

# Set up entrypoint

COPY docker-entrypoint.sh $BIN_DIR
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /home/workspace/
CMD ["bash"]
