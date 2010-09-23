# basic requirements
require 'sinatra/base'

# external requirements
require 'haml'
require 'appengine-apis/memcache'

# all application specific setup should go here
require 'environment'
require 'sinatra/common_helper'
require 'sinatra/authentication'
require 'sinatra/authorization'

class MyApp < Sinatra::Base
  
  helpers Sinatra::CommonHelper
  register Sinatra::Authentication
  register Sinatra::Authorization
  
  def initialize(app=nil)
    super(app)
    @memcache = AppEngine::Memcache.new
  end
  
  get '/' do
    if authenticated?
      haml :dashboard
    else
      haml :index
    end
  end
  
  get '/signin' do
    bounce_if_authenticated
    
    initialize_template
    haml :signin
  end
  
  post '/signin' do
    if authenticate(params[:email], params[:password])
      follow_url
    else
      redirect_with_message '/signin', 'Email or password wrong. Please try again'
    end
  end
  
  get '/signup' do
    bounce_if_authenticated
    
    initialize_template
    haml :signup
  end
  
  post '/signup' do
    account = Account.new(:email => params[:email], :username => params[:username], :password => params[:password], :password_confirmation => params[:password2])
    if account.save
      session[:account] = @account.id
    else
      redirect_with_message '/signup', 'Password does not match. Please try again'
    end
    
    redirect '/'
  end
  
  get '/signout' do
    logout!
    redirect '/'
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
  
  # specific routes for the production environment so that we do not reveal too much information about what went wrong...
  configure :production do
    not_found do
      # TODO some loggin
      redirect '/', 404
    end

    error do
      # TODO some loggin
      redirect '/', 500
    end  
  end
  
end
