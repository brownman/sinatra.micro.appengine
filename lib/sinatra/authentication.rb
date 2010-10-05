
require 'sinatra/base'
require 'sinatra/user'
require 'appengine-apis/memcache'

module Sinatra

  module Authentication

    module Helpers
         
      def bounce_if_authenticated
        redirect '/' if authenticated?
      end
    
      def require_authentication
        redirect_with_location('/signin', request.fullpath) unless authenticated?
      end
      
      def authenticate(email_or_username, password)
        if user = User.authenticate(email_or_username, password)
        	return memcache.add( session_id, user.id, Env.session_timeout)
        else
          logger.warn "Unable to authenticate user: " + email_or_username + "@" + password
          return false
        end
      end
      
      def authenticated?
        return false unless memcache.get( session_id)
        return true
      end
     
      def logout!
        memcache.delete( session_id)
      end
      
      def current_user
      	User.current_user( user_id) 
      end
      
      def user_id
      	memcache.get( session_id)
      end
    end

    def self.registered(app)
      app.helpers Authentication::Helpers
      
      app.get '/signin' do
        bounce_if_authenticated
    
        initialize_template
        haml :signin
      end
  
      app.post '/signin' do
        if authenticate(params[:email], params[:password])
          follow_url
        else
          redirect_with_message '/signin', 'Email or password wrong. Please try again'
        end
      end
  
      app.get '/signup' do
        bounce_if_authenticated
    
        initialize_template
        haml :signup
      end
  
      app.post '/signup' do
        user = User.new(:email => params[:email], :username => params[:username], :password => params[:password], :password_confirmation => params[:password2])
        if user.save
          authenticate user.email, params[:password]
          redirect '/'
        else
          redirect_with_message '/signup', 'Password does not match. Please try again'
        end
      end
  
      app.get '/signout' do
        logout!
        redirect '/'
      end
        
    end
        
  end # Authentication

  register Authentication
end 
