class AddCampaignReferenceToSuggestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :suggestions, :campaign, foreign_key: true
    Suggestion.find_each do |p|
      p.update(campaign: Campaign.current)
    end
  end
end
