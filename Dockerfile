
FROM alpine:3.4

MAINTAINER Josh Behrends <josh@behrends.us>


# 2003: Carbon line receiver port
# 7002: Carbon cache query port
# 8080: Graphite-Web port
EXPOSE 2003 2003/udp 7002 8080

# ---------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    supervisor \
    build-base \
    libffi-dev \
    python-dev \
    git \
    nginx \
    python \
    py-pip \
    py-cairo \
    py-parsing \
    py-mysqldb \
    pwgen \
    mysql-client && \
  pip install \
    --trusted-host http://d.pypi.python.org/simple --upgrade pip && \
  mkdir -p /opt /src /srv && \
  git clone https://github.com/graphite-project/whisper.git      /src/whisper      && \
  git clone https://github.com/graphite-project/carbon.git       /src/carbon       && \
  git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web && \
  cd /src/graphite-web &&  pip install -r requirements.txt && \
  cd /src/whisper      &&  python setup.py install --quiet && \
  cd /src/carbon       &&  python setup.py install --quiet && \
  cd /src/graphite-web &&  python setup.py install --quiet && \
  mv /opt/graphite/conf/graphite.wsgi.example /opt/graphite/webapp/graphite/graphite_wsgi.py && \
  apk del --purge \
    build-base \
    libffi-dev \
    python-dev \
    git && \
  rm -rf \
    /src \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

CMD /opt/startup.sh

# ---------------------------------------------------------------------------------------
