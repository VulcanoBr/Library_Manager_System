class CreateLibrarians < ActiveRecord::Migration[6.0]
  def change
    create_table :librarians do |t|
      t.string :name
      t.string :email
      t.string :identification
      t.string :password
      t.string :phone
      t.string :approved
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end
