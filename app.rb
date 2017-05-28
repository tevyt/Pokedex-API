require 'sinatra'
require 'sinatra/namespace'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: ENV['POKEDEX_DB_SERVER'],
  database: ENV['POKEDEX_DB'],
  user: ENV['POKEDEX_DB_USER'],
  password: ENV['POKEDEX_DB_PASSWORD']
)

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'pokemon', 'pokemon'
end


#model
class Pokemon < ActiveRecord::Base
end

#endpoint
namespace '/api' do
  before do
    content_type 'application/json'
  end

  get '/pokemon' do
    pokemon = Pokemon.all
    query = params[:q]
    if query
      pokemon = pokemon.where('LOWER(name) LIKE :query', query: "%#{query.downcase}%")
    end
    pokemon.to_json
  end

  get '/pokemon/:pokedex_number' do
    Pokemon.find(params[:pokedex_number]).to_json
  end
end
