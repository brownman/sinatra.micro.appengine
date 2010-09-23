
# Configure DataMapper to use the App Engine datastore 
require 'dm-core'

DataMapper.setup(:default, "appengine://auto")
DataMapper.repository.adapter.singular_naming_convention!

# setup constants, etc
SiteConfig = OpenStruct.new(
  :name => 'Your Application Name',
  :author => 'Your Name',
  :company => 'Your Company',
  :url_base => 'http://localhost:8080/'
)
