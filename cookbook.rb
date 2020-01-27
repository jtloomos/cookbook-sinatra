require "csv"
require_relative "recipe"

CSVOPTIONS = { col_sep: ',', force_quotes: true, quote_char: '"' }

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv if File.exist?(@csv_file_path)
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index - 1)
    write_csv
  end

  def destroy_all
    @recipes = []
    write_csv
  end

  def load_csv
    CSV.foreach(@csv_file_path, CSVOPTIONS) do |recipe|
      @recipes << Recipe.new(recipe[0], recipe[1], recipe[2], recipe[3], recipe[4] == 'true')
    end
  end

  def write_csv
    CSV.open(@csv_file_path, 'wb', CSVOPTIONS) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.difficulty, recipe.done]
      end
    end
  end

  def mark_as_read(index)
    @recipes[index].mark_as_done!
  end
end
