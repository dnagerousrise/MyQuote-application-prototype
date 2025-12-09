class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :fname, null: false
      t.string :lname, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :is_admin, default: false
      t.string :status, null: false, default: 'active'

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
