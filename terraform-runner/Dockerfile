FROM golang:1.11-stretch as plugins

# Install terraform providers (but not terraform, due to the -d), at latest
# versions.  This uses the very latest terraform, as well, but note that it
# is not even compiled -- just available in the GOPATH.
RUN go get -d github.com/hashicorp/terraform && \
    go get golang.org/x/tools/cmd/stringer && \
    go get github.com/ericchiang/terraform-provider-k8s && \
    go get github.com/taskcluster/terraform-provider-jsone

FROM debian:stretch

# install some random stuff
RUN apt-get update && apt-get install -y \
    jq \
    vim \
    nano \
    less \
    curl \
    unzip \
    gnupg2 \
    python \
    python3

# install terraform (change the version number here to use a different version)
RUN curl -o /terraform.zip https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && \
    cd /usr/bin/ && \
    unzip /terraform.zip && \
    rm -f /terraform.zip

# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt-get install -y apt-transport-https && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y azure-cli

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

# set up a non-root user (as a uid unlikely to match anyone's host userid)
RUN useradd -u 1500 -m tf
USER tf

# set up the homedir (as required by terraform-runner.sh)
RUN echo '. /repo/deployments/setup.sh' >> /home/tf/.bashrc && \
    mkdir -p /home/tf/setup-.terraform && \
    mkdir -p /home/tf/install-.terraform && \
    mkdir -p /home/tf/.terraform.d/plugins

# copy the plugins in from the earlier build, to the same directory as the terraform binary
COPY --from=plugins /go/bin/terraform-provider-k8s /go/bin/terraform-provider-jsone /usr/bin/

# make the home directory a volume, so that it can be persisted
VOLUME /home/tf

# and make the repository a volume, so that it can be bind-mounted from the outside
VOLUME /repo
WORKDIR /repo
