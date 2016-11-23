# Kuba

#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and http://varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {

    .host = "172.17.0.3";
    .port = "80";
}

# labs.webascrazy.net backend
backend labs_web {

    .host = "172.17.0.2";
    .port = "80";
}

# lol-bot.webascrazy.net backend
backend lol_slack_bot_web {

    .host = "172.17.0.3";
    .port = "8081";
}

sub vcl_recv {

    if (req.http.host ~ "^labs\.webascrazy\.net") {
        set req.backend_hint = labs_web;
    } else if (req.http.host ~ "^lol-bot\.webascrazy\.net") {
        set req.backend_hint = lol_slack_bot_web;
    }

}

sub vcl_backend_response {

}

sub vcl_deliver {

    if (obj.hits > 0) {
           set resp.http.X-Cache = "HIT";
    } else {
           set resp.http.X-Cache = "MISS";
    }

    if (req.url ~ "(\?|\&)debug=") {
        set resp.http.varnish-backend = req.backend_hint;
        set resp.http.varnish-req-url = req.url;
    }
}
