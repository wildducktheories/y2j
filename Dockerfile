FROM python
MAINTAINER jon@wildducktheories.com

RUN pip install pyyaml
RUN cd /usr/local/bin && curl -O http://stedolan.github.io/jq/download/linux64/jq && chmod ugo+x jq

ADD y2j.sh /usr/local/bin/

RUN ln -sf y2j.sh /usr/local/bin/y2j
RUN ln -sf y2j.sh /usr/local/bin/j2y
RUN ln -sf y2j.sh /usr/local/bin/yq

ENV META_IMAGE=wildducktheories/y2j

