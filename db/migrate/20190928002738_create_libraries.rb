class CreateLibraries < ActiveRecord::Migration[6.0]
  def change
    create_table :libraries do |t|
      t.string :name
      t.string :email
      t.string :location
      t.integer :borrow_limit
      t.float :overdue_fines
      t.references :university, null: false, foreign_key: true

      t.timestamps
    end
  end
end
