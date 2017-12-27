FROM registry.access.redhat.com/rhel7/rhel
LABEL maintainer "Arctiq Inc. <dev@arctiq.ca>"

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

RUN yum install -y gcc ruby-devel ruby-gems make gcc && \
    yum clean all

RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

RUN mkdir -p /fluentd/log
RUN mkdir -p /fluentd/etc /fluentd/plugins

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

EXPOSE 24224 5140

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
