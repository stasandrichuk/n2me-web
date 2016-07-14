class CreateEbooks < ActiveRecord::Migration
  def change
    create_table :ebooks do |t|
      t.string :image
      t.string :file
      t.string :author
      t.string :title
      t.text :description
      t.string :ean
      t.string :isbn
      t.integer :number_of_pages
      t.date :publication_date
      t.string :publisher_name
      t.string :record_reference

      t.timestamps null: false
    end
  end
end
