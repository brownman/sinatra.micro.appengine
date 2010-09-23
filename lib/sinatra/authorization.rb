
require 'sinatra/base'

module Sinatra

  module Authorization

    # Request-level helper methods for Sinatra routes.
    module Helpers
         
    end
  
    def self.registered(app)
      app.helpers Authorization::Helpers      
    end
  end

  register Authorization
end