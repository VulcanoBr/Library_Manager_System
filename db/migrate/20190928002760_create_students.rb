class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :email
      t.string :identification
      t.string :name
      t.string :password
      t.string :phone
      t.integer :max_book_allowed, default: 0
      t.string :google_token
      t.string :google_refresh_token
      t.string :provider
      t.string :uid
      t.references :university, null: false, foreign_key: true
      t.references :education_level, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
