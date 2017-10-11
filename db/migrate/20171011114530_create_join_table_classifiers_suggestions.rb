class CreateJoinTableClassifiersSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_join_table :classifiers, :suggestions do |t|
      t.references :classifier, foreign_key: true
      t.references :suggestion, foreign_key: true
      t.index [:suggestion_id, :classifier_id], unique: true, name: 'index_suggestion_id_and_classifier_id'
    end
  end
end