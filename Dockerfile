FROM ubuntu

ENV TZ Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive

RUN echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install -y --no-install-recommends tzdata wget \
    && rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && wget http://download.oray.com/peanuthull/linux/phddns_3.0_x86_64.deb \
    && apt-get purge -y --auto-remove wget \
    && dpkg -i phddns_3.0_x86_64.deb \
    && rm phddns_3.0_x86_64.deb \
    && apt-get clean

COPY run.sh .

CMD ["bash", "run.sh"]
