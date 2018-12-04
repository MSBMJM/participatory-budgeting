class AddSuggestionRefToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :suggestion, foreign_key: true
  end
end
