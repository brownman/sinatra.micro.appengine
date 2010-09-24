# basic requirements
require 'sinatra/base'

# external requirements
require 'haml'

# all application specific setup should go here
require 'environment'
require 'sinatra/common_helper'
require 'sinatra/appengine_helper'
require 'sinatra/authentication'
# require 'sinatra/authorization'


class MyApp < Sinatra::Base
  
  # some helpers
  helpers Sinatra::CommonHelper
  helpers Sinatra::AppEngineHelper
  
  # a bunch of extensions
  register Sinatra::Authentication
  # register Sinatra::Authorization
    
  get '/' do
    if authenticated?
      haml :dashboard
    else
      haml :index
    end
  end

  get '/test' do
    require_authentication
    
    haml :dashboard  
  end
  
  before do
    # do something
  end
  
  # general configuration, on spin-up
  configure do
    # do something
  end
  
  # specific routes for the production environment so we do not reveal too much information about what went wrong...
  configure :production do
    not_found do
      logger.warn "Route not found: " + request.fullpath
      redirect '/', 404
    end

    error do
      logger.error "Application-level exception: " + request.env['sinatra.error'].message
      redirect '/', 500
    end  
  end
  
end
