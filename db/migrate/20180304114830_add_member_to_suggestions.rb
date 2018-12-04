class AddMemberToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :proposing_member, :text
  end
end
