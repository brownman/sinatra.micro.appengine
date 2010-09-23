
require 'sinatra/base'

module Sinatra
  
  module CommonHelper
    
    def redirect_with_message(to_location, message)
      #flash[:message] = message
      redirect to_location
    end
    
    def redirect_with_location(to_location, next_location)
      redirect to_location + '?next=' + next_location
    end
    
    def follow_url
      if params[:next_url]
        redirect params[:next_url]
      end
      redirect '/'
    end
    
    def initialize_template
      @message = nil
      
      if params[:next]
        @next_location = params[:next]
      else
        @next_location = nil
      end
      
    end
    
  end
  
  helpers CommonHelper
end