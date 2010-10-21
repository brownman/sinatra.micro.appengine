# basic requirements
require 'sinatra/base'

# external requirements
require 'haml'

# all application specific setup should go here
require 'environment'
require 'sinatra/common_helper'
require 'sinatra/appengine_helper'
require 'sinatra/facebook_helper'
require 'sinatra/authentication'

class MyApp < Sinatra::Base
  
  # some helpers
  helpers Sinatra::CommonHelper
  helpers Sinatra::AppEngineHelper
  helpers Sinatra::FacebookHelper
   
  # my set of extensions
  register Sinatra::Authentication
    
  get '/' do
    if authenticated?
      haml :dashboard
    else
      haml :index
    end
  end
  
  get '/internal/1/keepalive' do
    # does nothing, is just there to receive periodic requests from a cron job. 
    # This way we always keep a 'warm' application instance, to avoid the long spin-up time 
    # of the JRuby environment 
  end
  
  get '/fb' do
    redirect fb_authentication_url
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
      redirect '/'
    end

    error do
      logger.error "Application-level exception: " + request.env['sinatra.error'].message
      redirect '/'
    end  
  end
  
end
