class CreateTelephones < ActiveRecord::Migration[7.0]
  def change
    create_table :telephones do |t|
      t.string :phone
      t.string :contact
      t.string :email_contact
      t.references :university, null: false, foreign_key: true

      t.timestamps
    end
  end
end
