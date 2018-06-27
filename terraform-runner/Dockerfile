FROM golang:1.10.3-stretch

# Install terraform + providers, latest versions,
# then clean up go source (300M) and GOROOT (500M)
RUN go get github.com/hashicorp/terraform && \
    go get golang.org/x/tools/cmd/stringer && \
    cd $GOPATH/src/github.com/hashicorp/terraform && \
    make dev && \
    go get -u github.com/ericchiang/terraform-provider-k8s && \
    go get -u github.com/taskcluster/terraform-provider-jsone && \
    rm -rf /go/src /usr/local/go

# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt-get update && \
    apt-get install apt-transport-https && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    apt-get update && \
    apt-get install azure-cli

# https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html
RUN apt-get install -y python3-pip && \
    pip3 install awscli

# https://cloud.google.com/sdk/docs/downloads-versioned-archives
# updated to the latest version, with kubectl
RUN curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-207.0.0-linux-x86_64.tar.gz | tar -C / -zxf - && \
    /google-cloud-sdk/install.sh -q && \
    PATH="${PATH}:/google-cloud-sdk/bin" && \
    gcloud components install kubectl --quiet && \
    gcloud components update
ENV PATH="${PATH}:/google-cloud-sdk/bin"

# install some random stuff
RUN apt-get install -y jq

# set up a non-root user (as a uid unlikely to match anyone's host userid)
RUN useradd -u 1500 -m tf
USER tf

ADD setup.sh /setup.sh

# set up the homedir (as required by terraform-runner.sh)
RUN echo '. /setup.sh' >> /home/tf/.bashrc && \
    mkdir -p /home/tf/setup-.terraform && \
    mkdir -p /home/tf/install-.terraform

# make the home directory a volume, so that it can be persisted
VOLUME /home/tf

# and make the repository a volume, so that it can be bind-mounted from the outside
VOLUME /repo
WORKDIR /repo
