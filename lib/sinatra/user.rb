
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

class User
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation
  
  property :id, Serial, :writer => :protected, :key => true
  property :ext_id, String, :length => (1..128)
  
  property :email, String, :length => (5..40), :unique => true, :format => :email_address
  property :username, String, :length => (2..32), :unique => true
  
  property :full_name, String, :length => (2..256)
  property :first_name, String, :length => (2..128)
  property :last_name, String, :length => (2..128)
  
  property :hashed_password, String, :writer => :protected
  property :salt, String, :writer => :protected
  
  property :created_at, DateTime
  property :account_type, String, :default => 'standard'
  property :active, Boolean, :default => true, :writer => :protected
  
  property :access_token1, String, :length => (2..256)
  property :access_token2, String, :length => (2..256)
  property :access_token3, String, :length => (2..256)
  
  validates_presence_of :password_confirmation
  validates_is_confirmed :password

  # Set the user's password, producing a salt if necessary
  def password=(pass)
    @password = pass
    self.salt = (1..12).map{(rand(26)+65).chr}.join if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def to_s
    self.username
  end 
  
  # some helper methods ...
  
  # Authenticate a user based upon a (username or e-mail) and password
  # Return the user record if successful, otherwise nil
  def self.authenticate(username_or_email, pass)
    current_user = first(:username => username_or_email) || first(:email => username_or_email)
    return nil if current_user.nil? || User.encrypt(pass, current_user.salt) != current_user.hashed_password
    current_user
  end
  
  def self.current_user(id)
    first(:id => id)  
  end
  
  def self.exists?(email)
    first(:email => email)  
  end
  
protected
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
  
end
