class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.float :amount, default: 0.0
      t.string :description, default: '', null: false
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :payments, :sender_id
    add_index :payments, :receiver_id
  end
end
