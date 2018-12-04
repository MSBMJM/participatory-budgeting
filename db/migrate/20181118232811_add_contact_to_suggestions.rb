class AddContactToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :contact, :text
  end
end
