class AddSolutionToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :solution, :text
  end
end
