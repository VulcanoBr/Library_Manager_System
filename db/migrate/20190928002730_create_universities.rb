class CreateUniversities < ActiveRecord::Migration[7.0]
  def change
    create_table :universities do |t|
      t.string :name
      t.string :email
      t.string :identification
      t.string :homepage

      t.timestamps
    end
  end
end
