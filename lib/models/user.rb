class User < ActiveRecord::Base
  validates :username, :presence => true
  validates :password, :presence => true
  validates :password, confirmation: true
end

class Dog < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop
end

class Cat < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop
end

class Shop < ActiveRecord::Base
  has_many :users
  has_many :dogs
  has_many :cats
end