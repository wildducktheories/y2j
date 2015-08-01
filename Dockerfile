FROM python
MAINTAINER jon@wildducktheories.com

RUN pip install pyyaml

ADD y2j.sh /usr/local/bin/

RUN ln -sf y2j.sh /usr/local/bin/y2j
RUN ln -sf y2j.sh /usr/local/bin/j2y

ENV INSTALL_DIR=/usr/local/bin
ENV META_IMAGE=wildducktheories/y2j