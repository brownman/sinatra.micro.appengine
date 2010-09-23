# basic requirements
require 'sinatra/base'

# all application specific setup should go here
require 'environment'
require 'common_helper'
require 'authentication'

class MyApp < Sinatra::Base
  helpers Sinatra::CommonHelper
  register Sinatra::Authentication
    
  configure do
    puts '+++ configure'  
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
    haml :signin
  end
  
  post '/signin' do
    if authenticate(params[:email], params[:password])
      redirect '/'
    else
      redirect_with_message '/signin', 'Email or password wrong. Please try again'
    end
  end
  
  get '/signup' do
    bounce_if_authenticated
    haml :signup
  end
  
  post '/signup' do
    @account = Account.new(:email => params[:email], :username => params[:username], :password => params[:password], :password_confirmation => params[:password2])
    if @account.save
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
  
  # specific routes for the production environment so that we do not reveal too much information about what went wrong...
  configure :production do
    not_found do
      # TODO some loggin
      redirect '/'
    end

    error do
      # TODO some loggin
      redirect '/'
    end  
  end
  
end
