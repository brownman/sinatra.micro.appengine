# include everything from the lib dir
$LOAD_PATH.unshift('lib') unless $LOAD_PATH.include?('lib')

# enable cookie-based session handling
use Rack::Session::Cookie, :key => 'ssid', :domain => 'test.com', :path => '/', :expire_after => 86400, :secret => 'secret'

# the main entry-point into this web-application
require 'app'
 
# launch the application now
run MyApp.new
