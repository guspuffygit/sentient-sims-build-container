FROM golang:1.24.5-bullseye


RUN wget https://go.dev/dl/go1.25.1.linux-amd64.tar.gz \
      && rm -rf /usr/local/go \
      && tar -C /usr/local -xzf go1.25.1.linux-amd64.tar.gz \
      && go version

RUN apt update \
      && apt install -y \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libsqlite3-dev \
        libreadline-dev \
        libffi-dev \
        wget \
        libbz2-dev \
      && wget -q https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz \
      && tar -xf Python-3.7.0.tgz \
      && cd Python-3.7.0 \
      && ./configure \
      && make -j$(nproc)

RUN cd Python-3.7.0 && make install \
      && python3.7 --version


FROM public.ecr.aws/docker/library/node:24.9.0

COPY --from=0 /usr/local/go /usr/local/go
COPY --from=0 /usr/local/bin /usr/local/bin
COPY --from=0 /usr/local/lib /usr/local/lib

RUN ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
      && unzip -q awscliv2.zip \
      && ./aws/install

RUN curl -fs https://get.docker.com -o get-docker.sh \
  && chmod a+x get-docker.sh \
  && ./get-docker.sh \
  && rm -f get-docker.sh

RUN apt-get update \
      && apt-get install -y \
          zip \
          git \
          gh \
          jq \
          nano \
      && rm -rf /var/lib/apt/lists/*