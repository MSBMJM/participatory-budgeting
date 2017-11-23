class AddConstituencyReferenceToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :constituency, foreign_key: true
    Campaign.find_each do |p|
      p.update(constituency: Constituency.current)
    end
  end
end
