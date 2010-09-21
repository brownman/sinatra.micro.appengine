
require 'sinatra/base'

module Sinatra
  
  module CommonHelper
      
    def bounce_if_authenticated
      redirect '/' if authenticated?
    end
    
    def redirect_with_message(to_location, message)
      #flash[:message] = message
      redirect to_location
    end
  end
  
  helpers CommonHelper
end