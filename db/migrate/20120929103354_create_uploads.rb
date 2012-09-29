class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :id
      t.string :slug
      t.string :filepath
      t.string :extension
      t.string :original_name
      t.string :pwd
      t.string :salt

      t.timestamps
    end
  end
end
