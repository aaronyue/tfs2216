FROM centos:6.6
COPY epel-6.repo /etc/yum.repos.d/epel.repo

RUN yum clean all && \
    yum -y install gperftools-devel.x86_64 jemalloc-devel.x86_64 gcc.x86_64 gcc-c++.x86_64 make.x86_64 automake.noarch libtool.x86_64 readline-devel.x86_64 libuuid-devel zlib-devel mysql-devel wget tar subversion.x86_64

ENV TBLIB_ROOT /usr/local

RUN mkdir /tmp/taobao && cd /tmp/taobao && \
    svn checkout -r 18 http://code.taobao.org/svn/tb-common-utils/trunk/ tb-common-utils && \
    sh tb-common-utils/build.sh && \
    rm -rf tb-common-utils && \
     svn co http://code.taobao.org/svn/tfs/tags/release-2.2.16 && cd release-2.2.16 && \
     sed -i '1i #include <stdint.h>' ./src/common/session_util.h && \
     sed -i '1584c char* pos = (char *) strstr(sub_dir, parents_dir);' ./src/name_meta_server/meta_server_service.cpp && \
     ./build.sh init && ./configure --prefix=/usr/local/tfs --with-release=yes && make && make install && \
    cd /tmp/taobao && rm -rf release-2.2.16 && \
    cd / && rm -rf /tmp/taobao /tmp/jemalloc-*