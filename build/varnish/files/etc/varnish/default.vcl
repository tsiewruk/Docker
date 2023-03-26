vcl 4.0;

backend default {
    .host = "netcorner";
    .port = "8080";
    .first_byte_timeout = 300s;
}

backend kt_product_picture_service {
    .host = "kt_product_picture";
    .port = "80";
}

backend cms_web_api {
    .host = "netcorner_cms";
    .port = "8081";
}

backend cms_static {
    .host = "netcorner_cms";
    .port = "8082";
}

backend kt_vip {
    .host = "kt_vip";
    .port = "80";
}

backend kt_payment {
    .host = "kt_payment";
    .port = "80";
}

backend kt_promotion_service {
    .host = "promotion";
    .port = "80";
}

backend wordpress_service {
    .host = "wordpress_service";
    .port = "80";
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
    if (req.http.host ~ "^static") {
        set req.backend_hint = kt_product_picture_service;
    } else if (req.http.host ~ "^media") {
        set req.backend_hint = default;
        set req.url = regsub(req.url, "^", "/media");
    } else if (req.http.host ~ "^api" && req.url ~ "^/payment") {
        set req.backend_hint = kt_payment;
    } else if (req.http.host ~ "^api" && req.url ~ "^/vip") {
        set req.backend_hint = kt_vip;
    } else if (req.http.host ~ "^nc-cms") {
        set req.backend_hint = cms_static;
    } else if (req.url ~ "^/rest-api/cms/") {
        set req.backend_hint = cms_web_api;
    } else if (req.url ~ "^/rest-api/sso") {
        set req.backend_hint = default;
    } else if (req.url ~ "^/rest-api/vip-acquire-customer") {
        set req.backend_hint = kt_vip;
    } else if (req.url ~ "^/rest-api/vip") {
        set req.backend_hint = default;
    } else if (req.url ~ "^/rest-api/promotion") {
        set req.backend_hint = kt_promotion_service;
    } else if (req.url ~ "^/rest-api/sales-channel") {
        set req.backend_hint = default;
    } else if (req.url ~ "^/rest-api/price-category") {
        set req.backend_hint = default;
    } else if (req.url ~ "^/rest-api/storage") {
        set req.backend_hint = default;
    } else if (req.url ~ "^/panel-admin/") {
        set req.backend_hint = kt_vip;
    } else if (req.url ~ "^/rest-api/") {
        set req.backend_hint = kt_vip;
    } else {
        if (req.url ~ "^/api/") {
            unset req.http.cookie;
        }
    }

    if (req.url ~ "^/informacje/") {
        if (req.http.host ~ "^komputronik[-\.]") {
            set req.http.host = "wp-pl-komputronik-informacje";
        }

        if (req.http.host ~ "^biznes[-\.]ktr[-\.]") {
            set req.http.host = "wp-pl-ktr-biznes-informacje";
        }

        if (req.http.host ~ "^d[-\.]ktr[-\.]") {
            set req.http.host = "wp-pl-ktr-informacje";
        }

        set req.url = regsub(req.url, "^/informacje/", "/");
        set req.backend_hint = wordpress_service;
    }

    if (req.url ~ "^/lp/") {
        if (req.http.host ~ "^komputronik[-\.]com[-\.]ua[-\.]") {
            set req.http.host = "wp-com-ua-komputronik-lp";
        }

        if (req.http.host ~ "^komputronik[-\.]") {
            set req.http.host = "wp-pl-komputronik-lp";
        }

        set req.url = regsub(req.url, "^/lp/", "/");
        set req.backend_hint = wordpress_service;
    }

    if (req.url ~ "^/informace/") {
        if (req.http.host ~ "^k24[-\.]cz[-\.]") {
            set req.http.host = "wp-cz-k24-informace";
        }

        set req.url = regsub(req.url, "^/informace/", "/");
        set req.backend_hint = wordpress_service;
    }

    if (req.url ~ "^/informacie/") {
        if (req.http.host ~ "^k24[-\.]sk[-\.]") {
            set req.http.host = "wp-sk-k24-informacie";
        }

        set req.url = regsub(req.url, "^/informacie/", "/");
        set req.backend_hint = wordpress_service;
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

    if (req.http.Authorization) {
        return (pass);
    }

    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    return (hash);
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
