require 'sinatra'
require 'sinatra/namespace'
require 'active_record'
require 'active_support'
require 'awrence'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: ENV['POKEDEX_DB_SERVER'],
  database: ENV['POKEDEX_DB'],
  username: ENV['POKEDEX_DB_USER'],
  password: ENV['POKEDEX_DB_PASSWORD']
)

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'pokemon', 'pokemon'
end


#model
class Pokemon < ActiveRecord::Base
  def to_json_hash
    {
     pokedexNumber: self.pokedex_number,
     name: self.name,
     speed: self.speed,
     specialAttack: self.special_attack,
     defence: self.defence,
     attack: self.attack,
     hp: self.hp,
     primaryType: self.primary_type,
     secondaryType: self.secondary_type
    }
  end
end

POKEMON_PER_PAGE = 20

#endpoint
namespace '/api' do
  before do
    content_type 'application/json'
    response.headers['Access-Control-Allow-Origin'] = '*'
  end


  get '/pokemon' do
    page = params[:page].to_i

    pokemon = Pokemon.all

    query = params[:q]
      
    pokemon = pokemon.where('LOWER(name) LIKE :query', query: "%#{query.downcase}%") if query
    
    pokemon.limit(POKEMON_PER_PAGE).offset(page.pred * POKEMON_PER_PAGE).map {|pokemon| pokemon.to_json_hash}.to_json
  end

  get '/pokemon/:pokedex_number' do
    pokedex_number = params[:pokedex_number].to_i
    previous_pokemon = pokedex_number == 1 ? nil : Pokemon.find(pokedex_number.pred)
    current_pokemon = Pokemon.find(pokedex_number)
    next_pokemon = pokedex_number == Pokemon.count ? nil : Pokemon.find(pokedex_number.succ)

    def get_pokemon_data(pokemon)
      {pokedexNumber: pokemon.pokedex_number, name: pokemon.name}
    end

    previous_pokemon_data = get_pokemon_data previous_pokemon if previous_pokemon
    current_pokemon_data = current_pokemon.to_json_hash
    next_pokemon_data = get_pokemon_data next_pokemon if next_pokemon

    {previousPokemon: previous_pokemon_data, pokemon: current_pokemon, nextPokemon: next_pokemon_data}.to_json
  end
end
