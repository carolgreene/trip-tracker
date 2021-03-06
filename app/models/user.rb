class User < ActiveRecord::Base
  has_secure_password

  has_many :trips

  validates_presence_of  :username, :email#, :password_digest
  validates_uniqueness_of :username, :email


  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find { |user| user.slug == slug}
  end


end
