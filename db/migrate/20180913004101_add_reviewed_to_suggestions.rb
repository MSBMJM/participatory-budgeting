class AddReviewedToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :reviewed, :boolean
  end
end
