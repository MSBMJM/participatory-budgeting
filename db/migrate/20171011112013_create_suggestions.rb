class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :budget, precision: 10, scale: 2, null: true
      t.text :image_data, null: true

      t.timestamps
    end
  end
end