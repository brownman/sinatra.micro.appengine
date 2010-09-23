$LOAD_PATH.unshift('lib') unless $LOAD_PATH.include?('lib')

# the main entry-point into this web-application
require 'app'

# launch as a Sinatra application
run MyApp.new