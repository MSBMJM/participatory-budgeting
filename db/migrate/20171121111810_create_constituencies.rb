class CreateConstituencies < ActiveRecord::Migration[5.0]
  def change
    create_table :constituencies do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :active, default: false, null: false
      t.timestamps
    end
  end
end