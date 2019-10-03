FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    locales \
    git \
    scons \
    libconfig++-dev \
    libboost-dev \
    libboost-iostreams-dev \
    libboost-serialization-dev \
    libyaml-cpp-dev \
    libncurses5-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install libconf \
    && pip3 install numpy

# Set up locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Build and install timeloop

RUN mkdir bld \
    && cd bld \
    && git clone https://github.com/NVlabs/timeloop.git \
    && cd ./timeloop/src \
    && ln -s ../pat-public/src/pat . \
    && cd .. \
    && scons \
    && cp build/timeloop /usr/local/bin \
    && cp build/evaluator /usr/local/bin

COPY ./exercises /home/tutorial

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]


