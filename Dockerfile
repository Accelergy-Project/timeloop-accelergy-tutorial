FROM ubuntu:18.04

ENV BUILD_DIR=/usr/local/src

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               locales \
               git \
               scons \
               python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd tutorial \
    && useradd -m -d /home/tutorial -c "Tutorial User Account" -s /usr/sbin/nologin -g tutorial tutorial \
    && if [ ! -d $BUILD_DIR ]; then mkdir $BUILD_DIR; fi

# Set up locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Cacti

WORKDIR $BUILD_DIR

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               g++ \
               libconfig++-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/HewlettPackard/cacti.git \
    && cd cacti \
    && make \
    && cp cacti /usr/local/bin \
    && apt-get remove -y \
               g++ \
               libconfig++-dev \
    && apt-get autoremove -y

# Accelergy

WORKDIR $BUILD_DIR

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install setuptools \
    && pip3 install wheel \
    && pip3 install libconf \
    && pip3 install numpy \
    && git clone https://github.com/nelliewu95/accelergy.git \
    && cd accelergy \
    && pip3 install . \
    && cd .. \
    && git clone https://github.com/nelliewu95/accelergy-aladdin-plug-in.git \
    && cd accelergy-aladdin-plug-in \
    && pip3 install . \
    && cd .. \
    && git clone https://github.com/nelliewu95/accelergy-cacti-plug-in.git \
    && cd accelergy-cacti-plug-in \
    && pip3 install . \
    && cp -r $BUILD_DIR/cacti /usr/local/share/accelergy/estimation_plug_ins/accelergy-cacti-plug-in/ \
    && chmod 777 /usr/local/share/accelergy/estimation_plug_ins/accelergy-cacti-plug-in/cacti \
    && cd ..

# Build and install timeloop

WORKDIR $BUILD_DIR

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               libconfig++ \
               libboost-iostreams1.65.1 \
               libboost-serialization1.65.1 \
               libyaml-cpp0.5v5 \
               libncurses5 \
               g++ \
               libconfig++-dev \
               libboost-dev \
               libboost-iostreams-dev \
               libboost-serialization-dev \
               libyaml-cpp-dev \
               libncurses5-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/NVlabs/timeloop.git \
    && cd ./timeloop/src \
    && ln -s ../pat-public/src/pat . \
    && cd .. \
    && scons \
    && cp build/timeloop /usr/local/bin \
    && cp build/evaluator /usr/local/bin \
    && apt-get remove -y \
               g++ \
               libconfig++-dev \
               libboost-dev \
               libboost-iostreams-dev \
               libboost-serialization-dev \
               libyaml-cpp-dev \
               libncurses5-dev \
    && apt-get autoremove -y

COPY ./exercises /usr/local/share/tutorial/exercises

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /home/tutorial
CMD ["bash"]
