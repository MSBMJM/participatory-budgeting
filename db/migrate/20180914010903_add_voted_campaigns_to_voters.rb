class AddVotedCampaignsToVoters < ActiveRecord::Migration[5.0]
  def change
    add_column :voters, :voted_campaigns, :text, default: ''
  end
end
