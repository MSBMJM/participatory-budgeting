class AddReviewStatusToSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :review_status, :string, default: 'waiting'
  end
end
