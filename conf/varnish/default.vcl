vcl 4.0;

backend default {

    .host = "172.17.0.5";
    .port = "80";
}

# labs.webascrazy.net backend
backend labs_web {

    .host = "172.17.0.6";
    .port = "80";
}

# lol-bot.webascrazy.net backend
backend lol_slack_bot_web {

    .host = "172.17.0.3";
    .port = "8081";
}

# v1.webascrazy.net backend
backend v1_webascrazy_net {

    .host = "172.17.0.5";
    .port = "80";
}

# socketorior.webascrazy.net backend
backend socketorior_web {

    .host = "172.17.0.4";
    .port = "8080";
}

# rox.webascrazy.net backend
backend rox_web {

    .host = "172.17.0.2";
    .port = "8033";
}

sub vcl_recv {

    unset req.http.Cookie;

    if (req.http.host ~ "^labs\.webascrazy\.net") {
        set req.backend_hint = labs_web;
    } else if (req.http.host ~ "^lol-bot\.webascrazy\.net") {
        set req.backend_hint = lol_slack_bot_web;
    } else if (req.http.host ~ "^v1\.webascrazy\.net") {
        set req.backend_hint = v1_webascrazy_net;
    } else if (req.http.host ~ "^socketorior\.webascrazy\.net") {
        set req.backend_hint = socketorior_web;
    } else if (req.http.host ~ "^rox\.webascrazy\.net") {
        set req.backend_hint = rox_web;
    } else if (req.http.host ~ "^roxbewith\.me") {
        set req.backend_hint = rox_web;
    } else if (req.http.host ~ "^www\.roxbewith\.me") {
        set req.backend_hint = rox_web;
    } else {
        set req.backend_hint = default;
    }

    # Do not cache anything
    return(pass);
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
