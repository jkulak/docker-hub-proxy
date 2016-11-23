FROM million12/varnish

COPY ./conf/varnish/default.vcl /etc/varnish/default.vcl
