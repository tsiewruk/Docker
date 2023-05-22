vcl 4.0;

backend default {
    .host = "netcorner";
    .port = "8080";
    .first_byte_timeout = 300s;
}

backend cms_web_api {
    .host = "netcorner_cms";
    .port = "8081";
}

backend cms_static {
    .host = "netcorner_cms";
    .port = "8082";
}

sub vcl_backend_response {
    set beresp.http.x-url = bereq.url;
}

sub vcl_deliver {
    unset resp.http.x-url;
    unset resp.http.x-riak-vclock;
    unset resp.http.link;
}

sub vcl_recv {
    if (req.http.host ~ "^nc-cms") {
        set req.backend_hint = cms_static;
    } else if (req.url ~ "^/rest-api/cms/") {
        set req.backend_hint = cms_web_api;
    } else {
        if (req.url ~ "^/api/") {
            unset req.http.cookie;
        }
    }

    if (req.url !~ "(?i)^/admin\.php/api/webApi/") {
        if (req.url ~ "^/admin\.php") {
            if (req.http.host !~ "^admin") {
                return (synth(301, "https://" + regsub(req.http.host, "^.+(-|\.local)", "admin\1") + req.url));
            }
        } else if (req.http.host ~ "^admin" && req.url == "/") {
            return (synth(301, "https://" + req.http.host + "/admin.php"));
        }
    }

    if (req.method == "PURGE") {
        return (purge);
    }

    if (req.method == "BAN") {
        ban("req.http.host == " + req.http.host + " && req.url == " + req.url);
        return(synth(200, "Ban added"));
    }

    if (req.url == "/ban_all") {
        ban("obj.http.x-url ~ /");
        return(synth(200, "Ban added for all objects"));
    }

    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    if (req.http.Authorization) {
        return (pass);
    }
    return (hash);
}

sub vcl_backend_fetch {
    set bereq.http.x-id = bereq.xid;
}

sub vcl_synth {
    if (resp.status == 301) {
        set resp.http.location = resp.reason;
        set resp.reason = "Moved";
        return (deliver);
    }
}

sub vcl_hash {
    if (req.http.cookie ~ "ktr_layout=") {
        set req.http.X-nc-layout = regsub(req.http.cookie, ".*ktr_layout=([^;]+);.*", "\1");
        hash_data(req.http.X-nc-layout);
        unset req.http.X-nc-layout;
    }
}

sub vcl_backend_response {
    set beresp.do_esi = true;

    if (!beresp.http.Cache-Control || beresp.http.Cache-Control !~ "max-age") {
        set beresp.ttl = 0s;
    }

    if (beresp.ttl > 0s) {
        unset beresp.http.set-cookie;
    }

    if (bereq.url ~ "^/api/") {
        unset beresp.http.set-cookie;
    }
}