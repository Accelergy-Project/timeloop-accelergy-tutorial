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
    && pip3 install numpy \
    && groupadd tutorial \
    && useradd -m -d /home/tutorial -c "Tutorial User Account" -s /usr/sbin/nologin -g tutorial tutorial \
    && mkdir /bld

# Set up locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Cacti
RUN cd /bld \
    && git clone https://github.com/HewlettPackard/cacti.git \
    && cd cacti \
    && make \
    && cp cacti /usr/local/bin


# Accelergy

RUN cd /bld \
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
    && cp -r /bld/cacti /usr/local/share/accelergy/estimation_plug_ins/accelergy-cacti-plug-in/ \
    && chmod 777 /usr/local/share/accelergy/estimation_plug_ins/accelergy-cacti-plug-in/cacti \
    && cd ..

# Build and install timeloop

RUN cd /bld \
    && git clone https://github.com/NVlabs/timeloop.git \
    && cd ./timeloop/src \
    && ln -s ../pat-public/src/pat . \
    && cd .. \
    && scons \
    && cp build/timeloop /usr/local/bin \
    && cp build/evaluator /usr/local/bin

COPY ./exercises /usr/local/share/tutorial/exercises

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]


