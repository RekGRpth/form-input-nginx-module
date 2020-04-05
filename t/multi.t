# vi:set ft= ts=4 sw=4 et fdm=marker:

use lib 'lib';
use Test::Nginx::Socket skip_all => 'not working at all';

plan tests => repeat_each() * 2 * blocks();

no_long_string();

run_tests();

#no_diff();

__DATA__

=== TEST 1: basic
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $foo name;
        array_join ' ' $foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /foo
name=calio&somethins&name=agentzh
--- response_body
calio agentzh
--- SKIP



=== TEST 2: combined
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input $foo name;
        set_form_input_multi $bar name;
        array_join ' ' $bar;
        echo $foo;
        echo $bar;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /foo
name=calio&something&name=agentzh&name=guoying&name=nobody&name=somebody
--- response_body
calio
calio agentzh guoying nobody somebody
--- SKIP



=== TEST 3: blank body
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $foo name;
        array_join ' ' $foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /foo
--- response_body eval
"\n"
--- SKIP



=== TEST 4: not fit
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $foo name;
        array_join ' ' $foo;
        echo $foo;
    }
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- request
POST /foo
a=b&c=d&e=f&g=h&i=j&k=l
--- response_body eval
"\n"
--- SKIP



=== TEST 5: not fit 2
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $foo name;
        array_join ' ' $foo;
        echo $foo;
    }
--- more_headers
Content-type: application/x-www-form-urlencoded
--- request
POST /foo
somename&name1=calio&sirname=calio
--- response_body eval
"\n"
--- SKIP



=== TEST 6: single value
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $foo name;
        array_join ' ' $foo;
        echo $foo;
    }
--- more_headers
Content-type: application/x-www-form-urlencoded
--- request
POST /foo
some=some&name=calio&any=any
--- response_body
calio
--- SKIP



=== TEST 7: inplace
--- main_config
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_form_input_module.so;
--- config
    location /foo {
        set_form_input_multi $name;
        array_join ' ' $name;
        echo $name;
    }
--- more_headers
Content-type: application/x-www-form-urlencoded
--- request
POST /foo
name=calio&name=agentzh
--- response_body
calio agentzh
--- SKIP


