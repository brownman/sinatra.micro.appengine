
require 'sinatra/base'
require 'appengine-apis/logger'
require 'appengine-apis/memcache'

module Sinatra

  module AppEngineHelper
    def logger
      @gae_logger ||= begin
        @gae_logger = AppEngine::Logger.new
        @gae_logger
      end
    end
      
    def memcache
      @gae_memcache ||= begin
        @gae_memcache = AppEngine::Memcache.new
        @gae_memcache
      end
    end
  end
  
  helpers AppEngineHelper
end