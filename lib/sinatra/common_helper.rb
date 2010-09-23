
require 'sinatra/base'
require 'base64'

module Sinatra
  
  module CommonHelper
    
    def redirect_with_message(to_location, message)
      redirect to_location
    end
    
    def redirect_with_location(to_location, next_location)
      redirect to_location + '?next=' + Base64.encode64( next_location)
    end
    
    def follow_url(default_url='/')
      redirect default_url unless params[:next_url]
      redirect Base64.decode64( params[:next_url])
    end
    
    def initialize_template
      @message = nil
      
      if params[:next]
        @next_url = params[:next]
      else
        @next_url = nil
      end
      
    end
    
    def set_cookie(c, v)
      response.set_cookie(c,v)
    end
    
    def cookie(c)
      return request.cookies[c]
    end
    
    def cookie?(c)
      return false unless request.cookies[c]
      return true 
    end
  end
  
  helpers CommonHelper
end