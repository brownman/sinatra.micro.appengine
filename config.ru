# include everything from the lib dir
$LOAD_PATH.unshift('lib') unless $LOAD_PATH.include?('lib')

# the main entry-point into this web-application
require 'app'

# enable cookie-based session handling
use Rack::Session::Cookie, :key => Env.session_key, :domain => Env.domain, :path => '/', :expire_after => Env.session_timeout, :secret => Env.secret
 
# launch the application now
run MyApp.new