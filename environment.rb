
# Configure DataMapper to use the App Engine datastore 
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")
DataMapper.repository.adapter.singular_naming_convention!

# setup constants, etc
Env = OpenStruct.new(
  :app_name => 'Your Application Name',
  :author => 'Your Name',
  :company => 'Your Company',
  :url_base => 'http://localhost:8080/',
  :domain => 'foo.com'
)
