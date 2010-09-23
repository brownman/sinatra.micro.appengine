
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
          return @memcache.add( cookie('ssid'), user.id, 3600) # TODO expiration should be controlled
        end
        return false
      end
      
      def authenticated?
        return false unless @memcache.get( cookie('ssid'))
        return true
      end
     
      def logout!
        @memcache.delete( cookie('ssid'))
      end
         
    end

    # A wrapper for the Rack::Session::Cookie middleware that allows an options
    # hash to be returned from the block given to the +use+ statement instead
    # of being provided up front.
    module Cookie
      def self.new(app, options={})
        options.merge!(yield) if block_given?
        Rack::Session::Cookie.new(app, options)
      end
    end
  
    def self.registered(app)
      app.helpers Authentication::Helpers
      
      # Parameters for the session cookie.
      app.set :session_name, 'ssid'
      app.set :session_path, '/'
      app.set :session_domain, nil
      app.set :session_expire, nil
      app.set :session_secret, nil

      app.use(Authentication::Cookie) do
        { :key => app.session_name,
          :path => app.session_path,
          :domain => app.session_domain,
          :expire_after => app.session_expire,
          :secret => app.session_secret
        }
      end
      
    end
    
  end # Authentication

  register Authentication
end 