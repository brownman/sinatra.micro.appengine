
require 'dm-core'
# place other dm- extensions here

# Configure DataMapper to use the App Engine datastore 
DataMapper.setup(:default, "appengine://auto")
DataMapper.repository.adapter.singular_naming_convention!

# other dependencies
require 'haml'
require 'models/account'

# setup constants, etc
SiteConfig = OpenStruct.new(
  :name => 'Your Application Name',
  :author => 'Your Name',
  :company => 'Your Company',
  :url_base => 'http://localhost:8080/'
)
