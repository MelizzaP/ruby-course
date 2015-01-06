class User < ActiveRecord::Base

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
  
end