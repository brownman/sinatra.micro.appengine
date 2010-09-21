
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
  :title => 'Your Application Name',
  :author => 'Your Name',
  :url_base => 'http://localhost:8080/'
)
