FROM ubuntu:xenial

WORKDIR /usr/src/sdk

RUN apt-get update && apt-get install -yq --no-install-recommends ca-certificates build-essential ocaml automake autoconf libtool wget python libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev alien cmake uuid-dev libxml2-dev

RUN wget --progress=dot:mega -O iclsclient.rpm http://registrationcenter-download.intel.com/akdlm/irc_nas/11414/iclsClient-1.45.449.12-1.x86_64.rpm && \
    alien --scripts -i iclsclient.rpm && \
    rm iclsclient.rpm

RUN wget --progress=dot:mega -O - https://github.com/intel/dynamic-application-loader-host-interface/archive/97c27a479f0b52a39740c7174a43aff8940b9914.tar.gz | tar -xz && \
    cd dynamic-application-loader-host-interface-97c27a479f0b52a39740c7174a43aff8940b9914 && \
    cmake . -DCMAKE_BUILD_TYPE=Release -DINIT_SYSTEM=SysVinit && \
    make install && \
    cd .. && rm -rf dynamic-application-loader-host-interface-97c27a479f0b52a39740c7174a43aff8940b9914

COPY install-psw.patch ./

RUN wget --progress=dot:mega -O - https://github.com/intel/linux-sgx/archive/sgx_2.4.tar.gz | tar -xz && \
    cd linux-sgx-sgx_2.4 && \
    patch -p1 -i ../install-psw.patch && \
    ./download_prebuilt.sh 2> /dev/null && \
    make -s -j$(nproc) sdk_install_pkg psw_install_pkg && \
    ./linux/installer/bin/sgx_linux_x64_sdk_2.4.100.48163.bin --prefix=/opt/intel && \
    ./linux/installer/bin/sgx_linux_x64_psw_2.4.100.48163.bin && \
    cd .. && rm -rf linux-sgx-sgx_2.4

WORKDIR /usr/src/app

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# For debug purposes
# COPY jhi.conf /etc/jhi/jhi.conf
