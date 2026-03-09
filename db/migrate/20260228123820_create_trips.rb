class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :name, null: false
      t.string :image_url
      t.text :short_description
      t.text :long_description
      t.integer :rating
      t.timestamps
    end

    add_index :trips, :name, unique: true
    add_index :trips, :rating
    add_index :trips, :created_at
  end
end
