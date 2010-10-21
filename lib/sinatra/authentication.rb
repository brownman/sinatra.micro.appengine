
require 'sinatra/base'
require 'sinatra/user'
require 'appengine-apis/memcache'
require 'appengine-apis/urlfetch'
require 'json'

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
        	return memcache.add( session_id, user.id, 86400)
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
        
      # facebook oauth callback
      app.get '/oauth/facebook/callback' do
        
        if !(params[:code] == nil)
          # exchange the code for an oauth access token
          response = AppEngine::URLFetch.fetch fb_token_exchange_url params[:code]
          
          # check the response status & content
          if response.code == '200'
            # extract the access_token
            p = query_string_to_hash("&" + response.body)
            
            if !(p['access_token'] == nil)
              access_token = p['access_token']
              
              # we have a valid oauth access_token now, get some basic user data, e.g. name and email next
              response = AppEngine::URLFetch.fetch fb_user_url access_token
              
              if response.code == '200'
                # finally we have all the information we needed. Now let's authenticate the user within this web app
                user_data = JSON.parse(response.body)
                
                # extract the basic data we need
                ext_id = user_data['id']
                email = user_data['email']
                first_name = user_data['first_name']
                last_name = user_data['last_name']
                full_name = user_data['name']
                
                # check if the user already exists
                user = User.exists? email
                if user == nil
                  # new user, create a record now
                  user = User.new(:ext_id => ext_id, :access_token1 => access_token, :account_type => 'facebook', :email => email, :full_name => full_name, :first_name => first_name, :last_name => last_name, :password => email, :password_confirmation => email)
                  if user.save
                    logger.info 'Created a new user based on Facebook data. Id=' + user.id.to_s
                    authenticate user.email, user.email
                  end
                else
                  logger.info 'Returning user authenticated by Facebook. Id=' + user.id.to_s
                  authenticate user.email, user.email
                end
                
                follow_url
                
              else
                logger.warn 'Facebook API did not reply with user data. Code=' + response.code
                logger.warn response.body
              end
              
            else
              logger.warn 'Facebook API did not reply with an access token.'
              logger.warn response.body
            end
          else
            logger.warn 'Facebook API did not reply with an access token. Code=' + response.code
            logger.warn response.body
          end
        else
          logger.warn 'Facebook API did not reply with an access code'
        end
        
        follow_url
        
      end
      
    end
        
  end # Authentication

  register Authentication
end 
