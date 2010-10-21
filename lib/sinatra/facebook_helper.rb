
require 'sinatra/base'
require 'sinatra/user'

module Sinatra
  
  module FacebookHelper
    
    def fb_authentication_url(scope='offline_access,email')
      fb_graph_url + '/oauth/authorize?client_id=' + Env.client_id + fb_redirect_uri + '&scope=' + scope
    end
    
    def fb_token_exchange_url(code)
      # escape the code !
      fb_graph_url + '/oauth/access_token?client_id=' + Env.client_id + fb_redirect_uri + '&client_secret=' + Env.client_secret + '&code=' + URI.escape(code)
    end
    
    def fb_user_url(access_token)
      fb_graph_url + '/me?access_token=' + URI.escape(access_token)
    end
    
    def fb_redirect_uri
      '&redirect_uri=' + Env.url_base + '/oauth/facebook/callback'
    end
    
    def fb_graph_url
      'https://graph.facebook.com'
    end
  end
  
  helpers FacebookHelper
end
