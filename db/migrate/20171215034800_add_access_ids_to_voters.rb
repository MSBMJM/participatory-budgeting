class AddAccessIdsToVoters < ActiveRecord::Migration[5.0]
  def change
    add_column :voters, :access_ids, :text
  end
end