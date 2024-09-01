class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :published
      t.date :publication_date
      t.string :edition
      t.string :cover
      t.text :summary
      t.boolean :special_collection
      t.integer :count, default: 0
      t.references :library, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.references :publisher, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
