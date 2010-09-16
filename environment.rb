
require 'dm-core'
# place other dm- extensions here

require 'haml'

SiteConfig = OpenStruct.new(
  :title => 'Your Application Name',
  :author => 'Your Name',
  :url_base => 'http://localhost:8080/'
)
               
# Configure DataMapper to use the App Engine datastore 
DataMapper.setup(:default, "appengine://auto")

