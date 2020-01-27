require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  @cookbook = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

get '/action_page.php' do
  @recipe = Recipe.new(params['recipename'], params['description'], params['preptime'], params['difficulty'])
  @cookbook = cookbook.add_recipe(@recipe)
  erb :index
end
