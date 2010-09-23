
require 'sinatra/base'
require 'sinatra/user'
require 'appengine-apis/memcache'

module Sinatra

  module Authentication

    # Request-level helper methods for Sinatra routes.
    module Helpers
         
      def bounce_if_authenticated
        redirect '/' if authenticated?
      end
    
      def require_authentication
        redirect_with_location('/signin', request.fullpath) unless authenticated?
      end
      
      def authenticate(email_or_username, password)
        if user = User.authenticate(email_or_username, password)
          return @memcache.add( cookie( Env.session_key), user.id, Env.session_timeout)
        end
        return false
      end
      
      def authenticated?
        return false unless @memcache.get( cookie(Env.session_key))
        return true
      end
     
      def logout!
        @memcache.delete( cookie(Env.session_key))
      end
         
    end

    def self.registered(app)
      app.helpers Authentication::Helpers      
    end
    
  end # Authentication

  register Authentication
end 