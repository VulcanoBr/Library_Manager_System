class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :website
      t.string :email
      t.references :nationality, null: false, foreign_key: true

      t.timestamps
    end
  end
end
