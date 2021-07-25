class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false, default: ''
      t.float :amount, default: 0.0

      t.timestamps
      t.index :email, unique: true
    end
  end
end
