require 'sinatra'
require 'sinatra/reloader'
require 'rest-client'
require 'json'
require './lib/petshop.rb'
require './config/environments.rb'
require './lib/models/user.rb'

# #
# This is our only html view...
#

configure do
  set :bind, '0.0.0.0'
  enable :sessions
end

get '/' do
  if session[:user_id]
    # TODO: Grab user from database

    #####  Active Record Change #####
    User.connection
    users = User.all
    users.find_by(id: session[:user_id]).as_json

    # Petshops::UserRepo.find_by_id(mydb, session[:user_id])

  end
  erb :index
end

##### I think we can comment this out #####
# def mydb
#   Petshops.create_db_connection('petserver')
# end
###########################################

# #
# ...the rest are JSON endpoints
#
get '/shops' do

  headers['Content-Type'] = 'application/json'
  # RestClient.get("http://pet-shop.api.mks.io/shops")

  #####  Active Record Change #####
  Shop.connection
  shops = Shop.all
  shops.to_json

  # JSON.generate(Petshops::ShopRepo.all(mydb))
end

post '/signin' do
  params = JSON.parse request.body.read

  username = params['username']
  password = params['password']

  #####  Active Record Change #####
  User.connection
  users = User.all
  creds = users.find_by(username: username).as_json

  # creds = Petshops::UserRepo.find_by_name(mydb, username)

  # TODO: Grab user by username from database and check password
  # user = { 'username' => 'alice', 'password' => '123' }

  if creds['password'] == password
    headers['Content-Type'] = 'application/json'
    # TODO: Return all pets adopted by this user
    # TODO: Set session[:user_id] so the server will remember this user has logged in
    session[:user_id] = creds['id']

    
    #####  Active Record Change #####
    Cat.connection
    cats = Cat.all
    cats = cats.where("owner_id = #{session[:user_id]}").as_json

    # cats = Petshops::CatRepo.find_by_owner_id(mydb, session[:user_id])

    creds['cats'] = []

    cats.each do |cat|
      creds['cats'] << {shopid: cat['shop_id'], name: cat['name'], imageUrl: cat['image_url'], adopted: true, id: cat['id']}
    end

    #####  Active Record Change #####
    Dog.connection
    dogs = Dog.all
    dogs = dogs.where("owner_id = #{session[:user_id]}").as_json

    # dogs = Petshops::DogRepo.find_by_owner_id(mydb, session[:user_id])

    creds['dogs'] = []
    dogs.each do |dog|
      creds['dogs'] << {shopid: dog['shop_id'], name: dog['name'], imageUrl: dog['image_url'], adopted: true, id: dog['id']}
    end

    JSON.generate(creds)
  else
    status 401
  end
end


#####  Extras #####
get '/signup' do
  erb :signup
end

post '/signup' do
end

###################

 # # # #
# Cats #
# # # #
get '/shops/:id/cats' do
  headers['Content-Type'] = 'application/json'
  id = params[:id]
  # TODO: Grab from database instead
  # RestClient.get("http://pet-shop.api.mks.io/shops/#{id}/cats")

  #####  Active Record Change #####
  Cat.connection
  cats = Cat.all
  data = cats.where("shop_id = #{id}").as_json

  # data = Petshops::CatRepo.find_by_shop_id(mydb, id)
  data.each do |line|
    line['adopted'] = (line['adopted'] == 't' ? true : false)
  end
  # JSON.generate(data)

  #####  Active Record Change #####
  data.to_json
end

put '/shops/:shop_id/cats/:id/adopt' do
  headers['Content-Type'] = 'application/json'
  shop_id = params[:shop_id]
  id = params[:id]
  owner_id = session[:user_id]
  # TODO: Grab from database instead
  # RestClient.put("http://pet-shop.api.mks.io/shops/#{shop_id}/cats/#{id}",
  #   { adopted: true }, :content_type => 'application/json')
  # TODO (after you create users table): Attach new cat to logged in user

  #####  Active Record Change #####
  Cat.connection
  cats = Cat.all
  cat = cats.find_by( id: id )
  cat.shop_id = shop_id
  cat.owner_id = owner_id
  save = cat.save

  # JSON.generate(Petshops::CatRepo.save(mydb, {
  #     'id' => id,
  #     'shop_id' => shop_id,
  #     'owner_id' => owner_id
  #   }))

  #####  Active Record Change #####
  save.to_json
end


 # # # #
# Dogs #
# # # #
get '/shops/:id/dogs' do
  headers['Content-Type'] = 'application/json'
  id = params[:id]
  # TODO: Update database instead
  # RestClient.get("http://pet-shop.api.mks.io/shops/#{id}/dogs")

  #####  Active Record Change #####
  Dog.connection
  dogs = Dog.all
  data = dogs.where("shop_id = #{id}").as_json

  # data = Petshops::DogRepo.find_by_shop_id(mydb, id)
  
  data.each do |line|
    line['adopted'] = (line['adopted'] == 't' ? true : false)
  end

  JSON.generate(data)

  #####  Active Record Change #####
  data.to_json
end

put '/shops/:shop_id/dogs/:id/adopt' do
  headers['Content-Type'] = 'application/json'
  shop_id = params[:shop_id]
  id = params[:id]
  owner_id = session[:user_id]
  # TODO: Update database instead
  # RestClient.put("http://pet-shop.api.mks.io/shops/#{shop_id}/dogs/#{id}",
  #   { adopted: true }, :content_type => 'application/json')
  # TODO (after you create users table): Attach new dog to logged in user

  #####  Active Record Change #####
  Dog.connection
  dogs = Dog.all
  dog = dogs.find_by( id: id)
  dog.shop_id = shop_id
  dog.owner_id = owner_id
  save = dog.save

  JSON.generate(Petshops::DogRepo.save(mydb, {
      'id' => id,
      'shop_id' => shop_id,
      'owner_id' => owner_id
    }))

  #####  Active Record Change #####
  save.to_json
end


$sample_user = {
  id: 999,
  username: 'alice',
  cats: [
    { shopId: 1, name: "NaN Cat", imageUrl: "http://i.imgur.com/TOEskNX.jpg", adopted: true, id: 44 },
    { shopId: 8, name: "Meowzer", imageUrl: "http://www.randomkittengenerator.com/images/cats/rotator.php", id: 8, adopted: "true" }
  ],
  dogs: [
    { shopId: 1, name: "Leaf Pup", imageUrl: "http://i.imgur.com/kuSHji2.jpg", happiness: 2, id: 2, adopted: "true" }
  ]
}
