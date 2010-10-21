
# Configure DataMapper to use the App Engine datastore 
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")
DataMapper.repository.adapter.singular_naming_convention!

# setup constants, etc
Env = OpenStruct.new(
  # about your web application
  :app_name => 'Your Application Name',
  :author => 'Your Name',
  :company => 'Your Company',
  :url_base => 'http://localhost:8080',
  :domain => 'foo.com',
  
  :secret => 'abc', # app secret, used to e.g. set default password...
  
  # required constants when using Facebook OAuth
  :client_id => '123',  # fb application ID
  :client_secret => '123' # fb application secret
  
)
