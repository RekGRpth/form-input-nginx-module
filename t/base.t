# vi:set ft= ts=4 sw=4 et fdm=marker:

use lib 'lib';
use Test::Nginx::Socket;

#repeat_each(3);

plan tests => repeat_each() * 2 * blocks();

no_long_string();

run_tests();

#no_diff();

__DATA__

=== TEST 1: blank body
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar1 {
        set_form_input $foo bar;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar1

--- response_body eval
"\n"



=== TEST 2: key not found
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar2 {
        set_form_input $foo bar;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar2
foo
--- response_body eval
"\n"
--- timeout: 3



=== TEST 3: key not found
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar3 {
        set_form_input $foo bar3;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar3
foo=
--- response_body eval
"\n"



=== TEST 4: basic key=value
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar4 {
        set_form_input $foo foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar4
foo=bar
--- response_body
bar



=== TEST 5: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar5 {
        set_form_input $foo foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar5
&
--- response_body eval
"\n"



=== TEST 6: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar6 {
        set_form_input $foo foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar6
foo&
--- response_body eval
"\n"



=== TEST 7: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $foo foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
foo=&
--- response_body eval
"\n"



=== TEST 8: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
&bar
--- response_body eval
"\n"
--- timeout: 4



=== TEST 9: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
&bar&
--- response_body eval
"\n"



=== TEST 10: test for spliter '&' and '='
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
&bar=
--- response_body eval
"\n"



=== TEST 11: test for spliter '&' and '='
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
&bar=foo
--- response_body
foo



=== TEST 12: test for spliter '&'
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
&&
--- response_body eval
"\n"



=== TEST 13: two keys
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar1 foo1;
        set_form_input $bar2 foo2;
        echo $bar1;
        echo $bar2;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /bar
foo1=bar1&foo2=bar2
--- response_body
bar1
bar2
--- timeout: 2



=== TEST 14: GET request
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
GET /bar
bar=foo
--- response_body eval
"\n"



=== TEST 15: no content type
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /bar {
        set_form_input $bar bar;
        echo $bar;
    }
--- request
GET /bar
bar=I have no content type
--- response_body eval
"\n"


