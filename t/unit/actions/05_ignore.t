use Test::Nginx::Socket::Lua;

repeat_each(3);
plan tests => repeat_each() * 4 * blocks();

no_shuffle();
run_tests();

__DATA__

=== TEST 1: IGNORE logs and does not exit
--- config
	location /t {
		access_by_lua '
			local actions = require "resty.waf.actions"

			actions.lookup["IGNORE"]({ _debug = true, _debug_log_level = ngx.INFO, _mode = "ACTIVE" }, {})

			ngx.log(ngx.INFO, "We should see this")
		';

		content_by_lua 'ngx.exit(ngx.HTTP_OK)';
	}
--- request
GET /t
--- error_code: 200
--- error_log
Ignoring rule for now
We should see this
--- no_error_log
[error]

