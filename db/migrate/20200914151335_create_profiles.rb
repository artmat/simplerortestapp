class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :firstname
      t.string :lastname
      t.string :country
      t.string :nativelang
      t.string :lang1
      t.string :lang2
      t.string :lang3
      t.string :url

      t.timestamps
    end
  end
end
