vcl 4.0;

backend default {

    .host = "172.17.0.2";
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

# www.webascrazy.net backend
backend www_webascrazy_net {

    .host = "172.17.0.5";
    .port = "80";
}

sub vcl_recv {

    unset req.http.Cookie;

    if (req.http.host ~ "^labs\.webascrazy\.net") {
        set req.backend_hint = labs_web;
    } else if (req.http.host ~ "^lol-bot\.webascrazy\.net") {
        set req.backend_hint = lol_slack_bot_web;
    } else if (req.http.host ~ "^webascrazy\.net") {
        set req.backend_hint = www_webascrazy_net;
    } else {
        set req.backend_hint = default;
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

    if (req.url ~ "(\?|\&)jkvarnish-debug=") {
        set resp.http.varnish-backend = req.backend_hint;
        set resp.http.varnish-req-url = req.url;
    }
}
