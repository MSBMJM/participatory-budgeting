class AddApprovedToSuggestions < ActiveRecord::Migration[5.0]

  def change
    add_column :suggestions, :approved, :boolean
  end

end