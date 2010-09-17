# basic requirements
require 'sinatra/base'

# all application specific setup should go here
require 'environment'
require 'sessions-gae'
require 'authentication-gae'

class MyApp < Sinatra::Base

  # the main route to get things rollin'
  get '/' do
    @message = 'main'
    haml :index
  end

  # specific routes for the production environment so that we do not reveal too much information about what went wrong...
  configure :production do
    not_found do
      status 404 # or simply return nothing ...  
    end

    error do
      status 500 # or simply return nothing ...
    end  
  end
  
end